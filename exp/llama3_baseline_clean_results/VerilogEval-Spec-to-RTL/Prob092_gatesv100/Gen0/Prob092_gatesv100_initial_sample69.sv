module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

integer i;

always @(in) begin
    for (i = 0; i < 100; i++) begin
        // out_both: check if current bit and its left neighbor are both '1'
        if (i == 99) begin
            out_both[i] = 0; // no left neighbor for most significant bit
        end else begin
            out_both[i] = in[i] & in[i+1];
        end

        // out_any: check if current bit or its right neighbor is '1'
        if (i == 0) begin
            out_any[i] = 0; // no right neighbor for least significant bit
        end else begin
            out_any[i] = in[i] | in[i-1];
        end

        // out_different: check if current bit is different from its left neighbor
        if (i == 99) begin
            out_different[i] = in[i] ^ in[0]; // wrap around to least significant bit
        end else begin
            out_different[i] = in[i] ^ in[i+1];
        end
    end
end

endmodule