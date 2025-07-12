module TopModule(
    input  clk,
    input  reset,
    input  [31:0] in,
    output reg [31:0] out
);

reg [31:0] prev_in;
reg [31:0] next_out; // Declare next_out as a reg at the module level

always @(posedge clk) begin
    if (reset) begin
        prev_in <= 32'd0;
        out <= 32'd0;
    end else begin
        prev_in <= in;
        next_out = out; // Initialize next_out with the current value of out
        for (int i = 0; i < 32; i++) begin
            if (~in[i] & prev_in[i]) begin
                next_out[i] = 1'b1; // Set the output bit if a falling edge is detected
            end else if (out[i] == 1'b1) begin
                next_out[i] = 1'b1; // Keep the output bit high if it was previously set
            end else begin
                next_out[i] = 1'b0; // Clear the output bit if no falling edge is detected and it was not previously set
            end
        end
        out <= next_out; // Assign the new value to out
    end
end

endmodule