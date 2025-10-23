module counter_12 (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       valid_count,
    output reg [3:0]  out
);

reg [3:0] next_out;

always @(*) begin
    if (!valid_count)
        next_out = out;               // Hold count if not enabled
    else if (out == 4'd11)
        next_out = 4'd0;             // Wrap around after 11
    else
        next_out = out + 4'd1;       // Increment count
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        out <= 4'd0;                 // Asynchronous reset to zero
    else
        out <= next_out;             // Update count with next value
end

endmodule