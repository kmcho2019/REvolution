module TopModule (
    input  [7:0] in,
    output [31:0] out
);
    // Sign-extend using signed type conversion
    assign out = $signed(in);
endmodule