module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

wire [3:0] shift_val = {q[2:0], data};
wire [3:0] count_val = q - {3'b0, count_ena};
wire [3:0] next_q = shift_ena ? shift_val : count_val;

always @(posedge clk) begin
    q <= next_q;
end

endmodule