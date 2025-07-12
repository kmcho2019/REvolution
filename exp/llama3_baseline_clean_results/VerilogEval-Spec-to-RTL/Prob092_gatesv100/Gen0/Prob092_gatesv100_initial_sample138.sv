module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

genvar i;
generate
    for (i = 0; i < 100; i++) begin
        // out_both: Check if current bit and its neighbor to the left are both '1'
        // For the most significant bit (in[99]), there's no neighbor to the left, so set out_both[99] to '0'
        if (i == 99) begin
            assign out_both[i] = 1'b0;
        end else begin
            assign out_both[i] = in[i] & in[i+1];
        end

        // out_any: Check if current bit or its neighbor to the right is '1'
        // For the least significant bit (in[0]), there's no neighbor to the right, so set out_any[0] to '0'
        if (i == 0) begin
            assign out_any[i] = 1'b0;
        end else begin
            assign out_any[i] = in[i] | in[i-1];
        end

        // out_different: Check if current bit is different from its neighbor to the left
        // For the most significant bit (in[99]), compare it with the least significant bit (in[0]) for wrap-around
        if (i == 99) begin
            assign out_different[i] = ~(in[i] ^ in[0]);
        end else begin
            assign out_different[i] = ~(in[i] ^ in[i+1]);
        end
    end
endgenerate

endmodule