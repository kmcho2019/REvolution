module TopModule(
    input [2:0] in,
    output [1:0] out
);

    wire [1:0] temp;

    // Use a full adder to count the number of '1's in the most significant two bits
    full_adder fa1(
       .a(in[0]),
       .b(in[1]),
       .cin(1'b0),
       .s(temp),
       .cout()
    );

    // Use a simple OR gate to combine the result with the least significant bit
    assign out[0] = temp[0] | in[2];
    assign out[1] = temp[1];

endmodule

module full_adder(
    input a,
    input b,
    input cin,
    output [1:0] s,
    output cout
);

    assign s[0] = a ^ b ^ cin;
    assign s[1] = 1'b0;
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule