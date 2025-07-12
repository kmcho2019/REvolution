module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // out_both: each bit indicates whether it and its neighbour to the left are '1'
    assign out_both[99] = 1'b0;
    for (genvar i = 98; i >= 0; i--) begin
        assign out_both[i] = in[i] & in[i+1];
    end

    // out_any: each bit indicates whether it or its neighbour to the right are '1'
    assign out_any[0] = 1'b0;
    for (genvar i = 1; i <= 99; i++) begin
        assign out_any[i] = in[i] | in[i-1];
    end

    // out_different: each bit indicates whether it is different from its neighbour to the left
    assign out_different[99] = in[99] ^ in[0];
    for (genvar i = 98; i >= 0; i--) begin
        assign out_different[i] = in[i] ^ in[i+1];
    end

endmodule