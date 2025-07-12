module counter_12(
    input  rst_n,
    input  clk,
    input  valid_count,
    output reg [3:0] out
);

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        out <= 4'b0000;  // Reset counter to 0 when rst_n is active low
    end else if (valid_count) begin
        if (out == 4'd11) begin
            out <= 4'b0000;  // Wrap counter around when it reaches 4'd11
        end else begin
            out <= out + 1;  // Increment counter by 1
        end
    end else begin
        out <= out;  // Keep counter unchanged when valid_count is 0
    end
end

endmodule