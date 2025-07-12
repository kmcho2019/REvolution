module counter_12 (
    input  wire       rst_n,        // Active low asynchronous reset
    input  wire       clk,          // Clock input
    input  wire       valid_count,  // Enable counting signal
    output reg [3:0]  out           // 4-bit count output
);

// Next count value combinational logic
reg [3:0] next_count;

always @(*) begin
    if (!valid_count)
        next_count = out;            // Hold current count if not valid
    else if (out == 4'd11)
        next_count = 4'd0;           // Wrap around to zero after 11
    else
        next_count = out + 1;        // Increment count by 1
end

// Sequential logic with asynchronous active low reset
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        out <= 4'b0000;              // Reset asynchronously to zero
    else
        out <= next_count;           // Update count at clock edge
end

endmodule