module counter_12 (
    input wire rst_n,
    input wire clk,
    input wire valid_count,
    output reg [3:0] out
);

always @(posedge clk) begin
    if (!rst_n) begin
        out <= 4'b0000;  // Synchronous reset
    end
    else if (valid_count) begin
        // Optimized increment with explicit wrap
        out <= (out == 4'b1011) ? 4'b0000 : out + 1'b1;
    end
    // else hold value (implicit)
end

endmodule