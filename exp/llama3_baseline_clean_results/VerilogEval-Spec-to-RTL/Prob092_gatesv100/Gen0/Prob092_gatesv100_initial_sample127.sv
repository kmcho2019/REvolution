module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

genvar i;
generate
    for (i = 0; i < 100; i++) begin
        // out_both: current bit and its neighbor to the left are both '1'
        if (i == 99) begin
            assign out_both[i] = 1'b0; // no neighbor to the left
        end else begin
            assign out_both[i] = in[i] & in[i+1];
        end

        // out_any: current bit or its neighbor to the right are '1'
        if (i == 0) begin
            assign out_any[i] = 1'b0; // no neighbor to the right
        end else begin
            assign out_any[i] = in[i] | in[i-1];
        end

        // out_different: current bit is different from its neighbor to the left
        if (i == 0) begin
            assign out_different[i] = in[i] ^ in[99]; // wrap around
        end else begin
            assign out_different[i] = in[i] ^ in[i-1];
        end
    end
endgenerate

endmodule