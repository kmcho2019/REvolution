module counter_12 (
    input wire rst_n,
    input wire clk,
    input wire valid_count,
    output reg [3:0] out
);

reg [3:0] next_out;

always @(*) begin
    if (!valid_count)
        next_out = out;
    else if (out == 4'd11)
        next_out = 4'd0;
    else
        next_out = out + 4'd1;
end

always @(posedge clk) begin
    if (!rst_n)
        out <= 4'b0000;
    else
        out <= next_out;
end

endmodule