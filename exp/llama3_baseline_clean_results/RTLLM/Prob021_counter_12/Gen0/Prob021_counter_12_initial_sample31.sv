module counter_12(
    input rst_n,  // Reset signal (active low)
    input clk,    // Clock signal
    input valid_count,  // Signal to enable counting
    output [3:0] out  // 4-bit output representing the current count value
);

reg [3:0] out_reg;  // Internal register to hold the count value

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset the counter when reset signal is active
        out_reg <= 4'b0000;
    end else if (valid_count) begin
        // Check if the current count value has reached the maximum count
        if (out_reg == 4'd11) begin
            // Wrap around to 0
            out_reg <= 4'b0000;
        end else begin
            // Increment the counter
            out_reg <= out_reg + 1;
        end
    end
end

assign out = out_reg;  // Continuous assignment to output port

endmodule