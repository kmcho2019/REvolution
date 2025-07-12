// Improved TopModule with integrated edge detection and simplified output update logic
module TopModule(
    input  clk,
    input  reset,
    input  [31:0] in,
    output reg [31:0] out
);

reg [31:0] prev_in;

always @(posedge clk) begin
    if (reset) begin
        out <= 32'd0;
        prev_in <= 32'd0;
    end else begin
        // Update prev_in with the current input signal
        prev_in <= in;
        
        // Update output bits based on falling edge detection and input signal changes
        for (int i = 0; i < 32; i++) begin
            if (prev_in[i] && !in[i]) begin
                // Set output bit high on falling edge detection
                out[i] <= 1'b1;
            end else if (out[i] && in[i]) begin
                // Reset output bit low when input bit goes high again
                out[i] <= 1'b0;
            end
        end
    end
end

endmodule