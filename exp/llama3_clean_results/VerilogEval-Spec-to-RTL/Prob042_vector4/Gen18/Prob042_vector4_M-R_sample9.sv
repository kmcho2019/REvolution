module TopModule (
    input  [7:0] in,
    output [31:0] out
);

    // Directly sign-extend the input within TopModule
    assign out = (in[7] == 1'b0) ? {24'd0, in} : {24'd1, in};

endmodule