module TopModule(
    input  [7:0] in,
    output [31:0] out
);

    // Use a conditional statement to determine whether the sign bit is 1 or 0
    // and then use bitwise operations to create the sign-extended output
    assign out = (in[7] == 1'b1)? ({24{1'b1}}, in) : ({24{1'b0}}, in);

endmodule