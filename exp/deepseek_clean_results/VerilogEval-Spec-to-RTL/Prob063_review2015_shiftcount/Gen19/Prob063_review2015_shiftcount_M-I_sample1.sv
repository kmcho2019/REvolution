module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

wire [3:0] shift_val = shift_ena ? {q[2:0], data} : 4'b0;
wire [3:0] count_val = count_ena ? {q[3]^(&q[2:0]), q[2]^&q[1:0], q[1]^q[0], ~q[0]} : 4'b0;

always @(posedge clk) begin
    if (shift_ena)
        q <= shift_val;
    else if (count_ena)
        q <= count_val;
    // else hold (implicit)
end

endmodule