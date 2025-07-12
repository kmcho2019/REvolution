module TopModule (
    input [99:0] in,
    output reg [99:0] out_both,
    output reg [99:0] out_any,
    output reg [99:0] out_different
);

genvar i;

generate
    for (i = 0; i < 100; i = i + 1) begin : output_gen
        // out_both logic
        always_comb begin
            if (i == 99) begin
                out_both[i] = 1'b0;  // No left neighbor for MSB
            end else begin
                out_both[i] = in[i] & in[i+1];
            end
        end

        // out_any logic
        always_comb begin
            if (i == 0) begin
                out_any[i] = 1'b0;  // No right neighbor for LSB
            end else begin
                out_any[i] = in[i] | in[i-1];
            end
        end

        // out_different logic with wrap-around
        always_comb begin
            if (i == 99) begin
                out_different[i] = in[i] ^ in[0];  // Wrap-around for MSB
            end else begin
                out_different[i] = in[i] ^ in[i+1];
            end
        end
    end
endgenerate

endmodule