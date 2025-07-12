module counter_12(
    input rst_n,  // Reset signal (active low)
    input clk,    // Clock signal
    input valid_count,  // Signal to enable counting
    output reg [3:0] out  // 4-bit output representing the current count value
);

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin  // If reset signal is active
        out <= 4'b0000;  // Reset counter to 0
    end else if (valid_count) begin  // If valid_count signal is 1
        if (out == 4'd11) begin  // If current count value is equal to 4'd11
            out <= 4'b0000;  // Wrap around and reset to 0
        end else begin
            out <= out + 1;  // Increment counter by 1
        end
    end
end

endmodule