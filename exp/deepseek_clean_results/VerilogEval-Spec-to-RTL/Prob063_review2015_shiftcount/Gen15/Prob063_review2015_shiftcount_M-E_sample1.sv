module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

wire [3:0] shift_out = {q[2:0], data};
wire [3:0] count_out = q ^ {4{count_ena}} & {1'b1, q[3:1] ^ (q[2:0] & {3{count_ena}})};

always @(posedge clk) begin
    q <= shift_ena ? shift_out : count_out;
end

endmodule