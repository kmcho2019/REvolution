module TopModule (
    input  [7:0] in,
    output [31:0] out
);

    // Sign-extend 'in' by replicating its sign bit (bit 7) 24 times,
    // then concatenating the original 8-bit input.
    assign out = { {24{in[7]}}, in };

endmodule