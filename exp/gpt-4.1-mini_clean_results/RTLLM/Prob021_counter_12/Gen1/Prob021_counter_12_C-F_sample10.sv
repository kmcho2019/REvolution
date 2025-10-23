module counter_12 (
    input  wire        rst_n,       // Active low asynchronous reset
    input  wire        clk,         // Clock input
    input  wire        valid_count, // Enable counting when high
    output reg  [3:0]  out          // 4-bit count output
);

localparam MAX_COUNT = 4'd11; // Terminal count value

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        out <= 4'b0000;            // Asynchronous reset to zero
    end else if (valid_count) begin
        if (out == MAX_COUNT)
            out <= 4'b0000;        // Wrap around to zero when max count reached
        else
            out <= out + 1;        // Increment count
    end
    // Hold value when valid_count is low
end

endmodule