module counter_12 (
    input wire rst_n,          // Active low reset
    input wire clk,            // Clock signal
    input wire valid_count,    // Enable counting when high
    output reg [3:0] out       // 4-bit counter output
);

parameter MAX_COUNT = 4'd11;

always @(posedge clk) begin
    if (!rst_n) begin
        out <= 4'b0000;        // Synchronous reset
    end
    else if (valid_count) begin
        if (out == MAX_COUNT)
            out <= 4'b0000;    // Explicit wrap for clarity
        else
            out <= out + 1'b1; // Increment otherwise
    end
end

endmodule