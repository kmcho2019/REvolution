module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

genvar i;
generate
    for (i = 0; i < 100; i = i + 1) begin
        // out_both: check if current bit and its neighbour to the left are 1
        if (i == 99) begin
            assign out_both[i] = 1'b0;
        end else begin
            assign out_both[i] = in[i] & in[i+1];
        end

        // out_any: check if current bit or its neighbour to the right is 1
        if (i == 0) begin
            assign out_any[i] = 1'b0;
        end else begin
            assign out_any[i] = in[i] | in[i-1];
        end

        // out_different: check if current bit is different from its neighbour to the left
        if (i == 99) begin
            assign out_different[i] = in[i] ^ in[0];
        end else begin
            assign out_different[i] = in[i] ^ in[i+1];
        end
    end
endgenerate

endmodule