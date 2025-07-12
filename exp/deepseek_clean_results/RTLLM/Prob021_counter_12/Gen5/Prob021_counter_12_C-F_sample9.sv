module counter_12 (
    input wire rst_n,         // Active low reset
    input wire clk,           // Clock signal
    input wire valid_count,   // Enable counting
    output reg [3:0] out      // 4-bit counter output
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        out <= 4'b0000;      // Async reset
    end
    else begin
        if (valid_count) begin
            if (out == 4'b1011)  // Wrap-around at 11
                out <= 4'b0000;
            else
                out <= out + 1'b1;  // Increment
        end
        // else hold value (implicit)
    end
end

endmodule