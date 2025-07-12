module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

wire operation_enable = shift_ena | count_ena;
wire [3:0] next_q = shift_ena ? {q[2:0], data} : (q - 1'b1);

always @(posedge clk) begin
    if (operation_enable) begin
        q <= next_q;
    end
end

endmodule