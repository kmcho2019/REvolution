module counter_12(
    input rst_n,  // Reset signal (active low)
    input clk,   // Clock signal
    input valid_count,  // Signal to enable counting
    output [3:0] out  // 4-bit output representing the current count value
);

reg [3:0] out_reg;  // Register to hold the current count value

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin  // Reset condition
        out_reg <= 4'b0000;  // Reset the counter to 0
    end else if (valid_count) begin  // Increment the counter if valid_count is 1
        if (out_reg == 4'd11) begin  // Check for wrap-around
            out_reg <= 4'b0000;  // Wrap around to 0
        end else begin
            out_reg <= out_reg + 1;  // Increment the counter
        end
    end
end

assign out = out_reg;  // Assign the current count value to the output port

endmodule