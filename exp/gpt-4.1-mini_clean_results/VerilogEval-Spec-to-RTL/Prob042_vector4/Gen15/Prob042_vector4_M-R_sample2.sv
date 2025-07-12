module TopModule (
    input  [7:0] in,
    output [31:0] out
);

    // Use direct replication operator for sign-extension
    assign out = { {24{in[7]}}, in };

endmodule