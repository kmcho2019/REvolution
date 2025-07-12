module counter_12 (
    input wire rst_n,
    input wire clk,
    input wire valid_count,
    output reg [3:0] out
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Active low reset
        out <= 4'b0000;
    end
    else begin
        if (valid_count) begin
            if (out == 4'd11) begin
                // Wrap around when reaching 11
                out <= 4'b0000;
            end
            else begin
                // Increment counter
                out <= out + 1'b1;
            end
        end
        // Else: maintain current value when valid_count is 0
    end
end

endmodule