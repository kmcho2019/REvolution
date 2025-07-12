module counter_12 (
    input wire rst_n,          // Active low reset
    input wire clk,            // Clock signal
    input wire valid_count,    // Enable counting when high
    output reg [3:0] out       // 4-bit counter output
);

// Custom LFSR sequence for 0-11 count
wire feedback = out[3] ^ out[2];  // x^4 + x^3 + 1 polynomial
wire [3:0] next_count = {out[2:0], feedback};

always @(posedge clk) begin
    if (!rst_n) begin
        out <= 4'b0000;
    end else if (valid_count) begin
        // Modified LFSR with custom wrap at 11 (1011)
        if (out == 4'b1011) begin
            out <= 4'b0000;
        end else begin
            out <= next_count;
        end
    end
end

endmodule