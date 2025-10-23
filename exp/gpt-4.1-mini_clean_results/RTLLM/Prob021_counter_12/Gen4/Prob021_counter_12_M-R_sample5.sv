module counter_12 (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       valid_count,
    output reg [3:0]  out
);

reg [3:0] next_count;

always @(*) begin
    if (!valid_count)
        next_count = out;                     // Hold current count if counting disabled
    else if (out == 4'd11)
        next_count = 4'b0000;                // Wrap around to zero at 11
    else
        next_count = out + 1'b1;             // Increment count
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        out <= 4'b0000;                      // Reset output synchronously on reset active low
    else
        out <= next_count;                   // Update count with next_count
end

endmodule