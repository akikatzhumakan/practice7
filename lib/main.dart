import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:practice_7/user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Router example',
      debugShowCheckedModeBanner: false,
      home: Container(
        color: Colors.white,
        child: PageView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          children: const [
            HomePage(),
            FormPage(),
          ],
        ),
      ),
    );
  }
}


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: ElevatedButton(
          child: const Text('NamePage'),
          onPressed: () {
            NewUser user = NewUser(
              fullname: 'Константин', 
              phone: '87077077077', 
              email: 'konstantin@mail.ru', 
              lifeStory: 'zhil da bil', 
              country: 'Norway');
            Navigator.push(context, 
              MaterialPageRoute(builder: (context){
                return UserPage(user: user);
              })
            );
          },
        ),
      ),
    );
  }
}


// ignore: must_be_immutable
class UserPage extends StatelessWidget {

  NewUser user = NewUser();
  UserPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('UserPage'),
      ),
      body: Container(
        padding: EdgeInsets.all(30),
        child: ListView(
          children: [
            ListTile(
              title: Text('${user.fullname}', style: TextStyle(fontSize: 20),),
              leading: Icon(Icons.person, size: 30,),
            ),
            ListTile(
              title: Text('${user.phone}', style: TextStyle(fontSize: 20),),
              leading: Icon(Icons.phone, size: 30,),
            ),
            ListTile(
              title: Text('${user.email}', style: TextStyle(fontSize: 20),),
              leading: Icon(Icons.email, size: 30,),
            ),
            ListTile(
              title: Text('${user.lifeStory}', style: TextStyle(fontSize: 20),),
              leading: Icon(Icons.hourglass_bottom, size: 30,),
            ),
            ListTile(
              title: Text('${user.country}', style: TextStyle(fontSize: 20),),
              leading: Icon(Icons.map, size: 30,),
            ),
          ],
        ),
      ),
    );
  }
}

// task2

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {

  //states

  final _formKey = GlobalKey<FormState>();

  List<String> _contries = ['Kazakhstan', 'USA', 'Norway', 'Switzerland'];
  String selectedCountry = '';

  bool _hidePass = true;

  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _lifeStoryController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final FocusNode _fullnameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _lifeStoryFocus = FocusNode();
  final FocusNode _countryFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  //functions
  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _fullnameController.dispose();
    _lifeStoryController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullnameFocus.dispose();
    _phoneFocus.dispose();
    _emailFocus.dispose();
    _lifeStoryFocus.dispose();
    _countryFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  void printControllerValues() {
    print('Fullname: ${_fullnameController.text}');
    print('Phone: ${_phoneController.text}');
    print('Email: ${_emailController.text}');
    print('Life Story: ${_lifeStoryController.text}');
    print('Password: ${_passwordController.text}');
    print('Confirm Password: ${_confirmPasswordController.text}');
    print('validate: ${_formKey.currentState?.validate()}');
  }

  bool _validatePhoneNumber(String input) {
    final phoneExp = RegExp(r'^\d{11}$');
    print('dada $phoneExp');
    return phoneExp.hasMatch(input);
  }

  bool _validateFullName(String input) {
    if (input.isEmpty) {
      return false;
    }
    final nameExp = RegExp(r'^[a-zA-Zа-яА-ЯёЁ]+(?:[ -][a-zA-Zа-яА-ЯёЁ]+)*$');
    return nameExp.hasMatch(input);
  }

  bool _validateEmail(String input) {
    final emailExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailExp.hasMatch(input);
  }

  _validatePassword(String input) {
    if (input.isEmpty){
      return 'Passwords must be filled in';
    }
    if (input.length <= 8){
      return "Password has to be 9 or more letters";
    } else if (_passwordController.text != _confirmPasswordController.text){
      return 'Passwords must match';
    }
    return null;
  }

  void fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus){
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  //interface
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form example'),
        centerTitle: true,
      ),
      body: Column(
        children: [ 
          Form(
            key: _formKey,
            child: Expanded(
              child: ListView(
                padding: EdgeInsets.all(20),
                children: [
                  TextFormField(
                    focusNode: _fullnameFocus,
                    decoration: InputDecoration(
                      labelText: 'Full name*',
                      hintText: 'What do people call you?',
                      prefixIcon: Icon(Icons.person),
                      suffixIcon: IconButton(
                        onPressed: () => setState(() {
                          _fullnameController.clear();
                        }),
                        icon: Icon(Icons.delete_outline, color: Colors.red),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.blue, width: 1),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.red, width: 1),
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.red, width: 1),
                      ),
                    ),
                    controller: _fullnameController,
                    onFieldSubmitted: (_) {
                      fieldFocusChange(context, _fullnameFocus, _phoneFocus);
                    },
                    validator: (input) {
                      if (!_validateFullName(input!)) {
                        return 'Invalid fullname';
                      }
                      return null;
                    },
                    onChanged: (text){
                      setState(() {
                        _fullnameController.text = text;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    focusNode: _phoneFocus,
                    decoration: InputDecoration(
                      labelText: 'Phone*',
                      hintText: 'Where can we reach you?',
                      helperText: 'Phone format: XXXXXXXXXXX',
                      prefixIcon: Icon(Icons.phone),
                      suffixIcon: IconButton(
                        onPressed: () => setState(() {
                          _phoneController.clear();
                        }),
                        icon: Icon(Icons.delete_outline, color: Colors.red),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.blue, width: 1),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.red, width: 1),
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.red, width: 1),
                      ),
                    ),
                    controller: _phoneController,
                    onFieldSubmitted: (_) {
                      fieldFocusChange(context, _phoneFocus, _emailFocus);
                    },
                    validator: (input) {
                      if (!_validatePhoneNumber(input!)) {
                        return 'Invalid phone format.';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.phone,
                    inputFormatters:[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (text){
                      setState(() {
                        _phoneController.text = text;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    focusNode: _emailFocus,
                    decoration: InputDecoration(
                      labelText: 'Email*',
                      hintText: 'How can we text you?',
                      prefixIcon: Icon(Icons.email),
                      suffixIcon: IconButton(
                        onPressed: () => setState(() {
                          _emailController.clear();
                        }),
                        icon: Icon(Icons.delete_outline, color: Colors.red),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.blue, width: 1),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.red, width: 1),
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.red, width: 1),
                      ),
                    ),
                    controller: _emailController,
                    onFieldSubmitted: (_) {
                      fieldFocusChange(context, _emailFocus, _lifeStoryFocus);
                    },
                    validator: (input) {
                      if (!_validateEmail(input!)) {
                        return 'Invalid email.';
                      }
                      return null;
                    },
                    onChanged: (text){
                      setState(() {
                        _emailController.text = text;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    focusNode: _lifeStoryFocus,
                    decoration: InputDecoration(
                      labelText: 'Lify story',
                      hintText: 'Tell us your life story',
                      helperText: 'Keep it short, this is just a demo',
                      prefixIcon: Icon(Icons.hourglass_bottom),
                      suffixIcon: IconButton(
                        onPressed: () => setState(() {
                          _lifeStoryController.clear();
                        }),
                        icon: Icon(Icons.delete_outline, color: Colors.red),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.blue, width: 1),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.red, width: 1),
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.red, width: 1),
                      ),
                    ),
                    maxLines: 3,
                    controller: _lifeStoryController,
                    onChanged: (text){
                      setState(() {
                        _lifeStoryController.text = text;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField(
                    focusNode: _countryFocus,
                    decoration: const InputDecoration(
                      labelText: 'Country*',
                      hintText: 'What country are you from?',
                      prefixIcon: Icon(Icons.map),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.blue, width: 1),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.red, width: 1),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.red, width: 1),
                      ),
                    ),
                    items: _contries.map((country) {
                      return DropdownMenuItem(
                        value: country,
                        child: Text(country),
                      );
                    }).toList(), 
                    validator: (val){
                      return val == null ? 'Please select a country' : null;
                    },
                    onChanged: (data) {
                      setState(() {
                        selectedCountry = data!;
                        fieldFocusChange(context, _countryFocus, _passwordFocus);
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    focusNode: _passwordFocus,
                    decoration: InputDecoration(
                      labelText: 'Password*',
                      hintText: 'Enter the password',
                      prefixIcon: const Icon(Icons.shield_sharp),
                      suffixIcon: IconButton(
                        onPressed: () => setState(() {
                          _hidePass = !_hidePass;
                        }),
                        icon: _hidePass ? Icon(Icons.visibility_off, color: Colors.grey,) : Icon(Icons.visibility)
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.blue, width: 1),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.red, width: 1),
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.red, width: 1),
                      ),
                    ),
                    obscureText: _hidePass,
                    controller: _passwordController,
                    onFieldSubmitted: (_) {
                      fieldFocusChange(context, _passwordFocus, _confirmPasswordFocus);
                    },
                    validator: (input) {
                      return _validatePassword(input!);
                    },
                    onChanged: (text){
                      setState(() {
                        _passwordController.text = text;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    focusNode: _confirmPasswordFocus,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password*',
                      hintText: 'Enter the confirm password',
                      prefixIcon: Icon(Icons.shield_sharp),
                      suffixIcon: IconButton(
                        onPressed: () => setState(() {
                          _hidePass = !_hidePass;
                        }),
                        icon: _hidePass ? Icon(Icons.visibility_off, color: Colors.grey,) : Icon(Icons.visibility)
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.blue, width: 1),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.red, width: 1),
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.red, width: 1),
                      ),
                    ),
                    obscureText: _hidePass,
                    controller: _confirmPasswordController,
                    onFieldSubmitted: (_){
                      _confirmPasswordFocus.unfocus();
                    },
                    validator: (input) {
                      return _validatePassword(input!);
                    },
                    onChanged: (text){
                      setState(() {
                        _confirmPasswordController.text = text;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: (){
                      if (_formKey.currentState!.validate()){
                        printControllerValues();
                        Navigator.push(context, 
                          MaterialPageRoute(builder: (context){
                            return UserPage(user: NewUser(
                              fullname: _fullnameController.text,
                              phone: _phoneController.text,
                              email: _emailController.text,
                              lifeStory: _lifeStoryController.text,
                              country: selectedCountry,
                            ));
                          })
                        );
                      }
                    }, 
                    child: Text('Submit')
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}