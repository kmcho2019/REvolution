module TopModule(a, b, cin, cout, sum);
    input a;
    input b;
    input cin;
    output cout;
    output sum;

    assign sum = a ^ b ^ cin; // XOR of a, b, and cin for sum
    assign cout = (a & b) | (a & cin) | (b & cin); // OR of AND operations for carry-out

endmodule