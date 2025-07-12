module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

wire clk_enable = shift_ena | count_ena;
wire gated_clk = clk & clk_enable;

always @(posedge gated_clk) begin
    q <= shift_ena ? {q[2:0], data} : (q - count_ena);
end

endmodule