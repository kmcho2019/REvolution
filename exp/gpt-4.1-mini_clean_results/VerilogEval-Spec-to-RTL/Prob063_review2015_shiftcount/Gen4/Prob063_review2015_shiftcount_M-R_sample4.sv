module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

wire [3:0] next_q;

assign next_q = (shift_ena) ? {data, q[3:1]} :
                (count_ena) ? (q - 1'b1) :
                q;

always @(posedge clk) begin
    q <= next_q;
end

endmodule