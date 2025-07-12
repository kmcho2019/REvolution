module counter_12(
    input rst_n, // Reset signal (active low)
    input clk,   // Clock signal
    input valid_count, // Signal to enable counting
    output [3:0] out // 4-bit output representing the current count value
);

reg [3:0] out_reg; // Internal register to store the count value

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset the counter when rst_n is low
        out_reg <= 4'b0000;
    end else if (valid_count) begin
        // Check if the current count value is equal to the maximum count value
        if (out_reg == 4'd11) begin
            // Wrap around and reset to 0
            out_reg <= 4'b0000;
        end else begin
            // Increment the counter by 1
            out_reg <= out_reg + 1;
        end
    end
end

assign out = out_reg; // Assign the internal register value to the output

endmodule