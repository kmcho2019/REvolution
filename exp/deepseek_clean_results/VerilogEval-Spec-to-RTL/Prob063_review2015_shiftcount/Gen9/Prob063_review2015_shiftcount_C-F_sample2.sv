module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

wire [3:0] next_shift = shift_ena ? {q[2:0], data} : q;
wire [3:0] next_count = count_ena ? q - 1'b1 : q;
wire [3:0] next_q = shift_ena ? next_shift : next_count;

always @(posedge clk) begin
    q <= next_q;
end

endmodule