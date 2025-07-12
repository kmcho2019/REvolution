module counter_12(
    input rst_n,
    input clk,
    input valid_count,
    output reg [3:0] out
);

always @(posedge clk) begin
    if (!rst_n) begin
        // Reset counter to 0 when reset signal is active
        out <= 4'b0000;
    end else if (valid_count) begin
        // Check if current count value is equal to maximum count value
        if (out == 4'd11) begin
            // Wrap counter around to 0
            out <= 4'b0000;
        end else begin
            // Increment counter
            out <= out + 1'b1;
        end
    end
end

endmodule