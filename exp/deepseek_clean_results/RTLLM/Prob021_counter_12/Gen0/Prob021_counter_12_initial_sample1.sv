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
            // Increment counter when enabled
            if (out == 4'd11) begin
                // Wrap around at 11
                out <= 4'b0000;
            end
            else begin
                // Normal increment
                out <= out + 1'b1;
            end
        end
        // Else hold value (implicit)
    end
end

endmodule