module TopModule (
    input [7:0] in,
    output [31:0] out
);

    // The current implementation is already optimal for most synthesis tools.
    // An alternative, more traditional approach using bitwise operations could be:
    // assign out = (in[7]) ? (32'd-1 << 8) | in : {24'd0, in};
    // However, the replication operator version is more concise and should be optimized by the synthesis tool.
    assign out = { {24{in[7]}}, in };

endmodule