module TopModule(a, b, cin, cout, sum);
  input a, b, cin;
  output cout, sum;

  assign sum = a ^ b ^ cin; // XOR of the three inputs gives the sum
  assign cout = (a & b) | (a & cin) | (b & cin); // Cout is 1 if any two or all inputs are 1

endmodule