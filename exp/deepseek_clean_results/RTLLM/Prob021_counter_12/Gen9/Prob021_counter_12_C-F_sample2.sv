module counter_12 (
    input wire rst_n,          // Active low reset
    input wire clk,            // Clock signal
    input wire valid_count,    // Enable counting when high
    output reg [3:0] out       // 4-bit counter output
);

always @(posedge clk) begin
    if (!rst_n) begin
        out <= 4'b0000;
    end else if (valid_count) begin
        // Natural overflow handles wrap-around from 11 to 0
        if (out == 4'b1011)  // Optional: explicit for clarity
            out <= 4'b0000;
        else
            out <= out + 1'b1;
    end
    // else hold value (implicit)
end

endmodule