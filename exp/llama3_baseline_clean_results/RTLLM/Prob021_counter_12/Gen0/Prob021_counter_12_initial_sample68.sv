module counter_12(
    input rst_n,
    input clk,
    input valid_count,
    output reg [3:0] out
);

    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset counter to 0 when reset signal is active low
            out <= 4'b0000;
        end else if (valid_count) begin
            // Check if the current count value is equal to the maximum count value
            if (out == 4'd11) begin
                // Wrap around to 0
                out <= 4'b0000;
            end else begin
                // Increment the counter by 1
                out <= out + 1;
            end
        end
    end

endmodule