module counter_12 (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       valid_count,
    output reg [3:0]  out
);

wire ce = valid_count;

always @(posedge clk) begin
    if (!rst_n)
        out <= 4'b0000;
    else if (ce)
        out <= (out == 4'd11) ? 4'b0000 : out + 1'b1;
end

endmodule