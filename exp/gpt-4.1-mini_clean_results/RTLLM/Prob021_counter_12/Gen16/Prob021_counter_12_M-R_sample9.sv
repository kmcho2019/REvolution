module counter_12 (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       valid_count,
    output reg [3:0]  out
);

wire terminal_count;
assign terminal_count = out[3] & ~out[2] & out[1] & out[0];

always @(posedge clk) begin
    if (!rst_n)
        out <= 4'b0000;
    else if (valid_count)
        out <= (terminal_count) ? 4'b0000 : out + 1'b1;
    else
        out <= out; // Hold current count when valid_count is low
end

endmodule