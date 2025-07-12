module counter_12 (
    input wire rst_n,
    input wire clk,
    input wire valid_count,
    output reg [3:0] out
);

reg [3:0] next_count;

always @(*) begin
    if (out == 4'd11)
        next_count = 4'd0;
    else
        next_count = out + 4'd1;
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        out <= 4'd0;
    else if (valid_count)
        out <= next_count;
    else
        out <= out;  // hold current count if not counting
end

endmodule