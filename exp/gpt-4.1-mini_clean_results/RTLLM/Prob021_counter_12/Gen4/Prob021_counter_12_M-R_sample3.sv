module counter_12 (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       valid_count,
    output reg [3:0]  out
);

reg [3:0] next_out;

always @(*) begin
    if (!valid_count)
        next_out = out;                        // Hold current count if not enabled
    else if (out == 4'd11)
        next_out = 4'd0;                      // Wrap around to 0 after 11
    else
        next_out = out + 1'b1;                // Increment count
end

always @(posedge clk) begin
    if (!rst_n)
        out <= 4'd0;                          // Synchronous active-low reset
    else
        out <= next_out;                      // Update count with next state
end

endmodule