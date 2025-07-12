module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    // Generate 32 identical bit processors
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : bit_processor
            reg prev_bit = 1'b0;
            reg captured_bit = 1'b0;
            
            always @(posedge clk) begin
                if (reset) begin
                    prev_bit <= 1'b0;
                    captured_bit <= 1'b0;
                end
                else begin
                    // Detect falling edge and capture
                    if (prev_bit && !in[i])
                        captured_bit <= 1'b1;
                    // Store current input for next cycle
                    prev_bit <= in[i];
                end
            end
            
            assign out[i] = captured_bit;
        end
    endgenerate

endmodule