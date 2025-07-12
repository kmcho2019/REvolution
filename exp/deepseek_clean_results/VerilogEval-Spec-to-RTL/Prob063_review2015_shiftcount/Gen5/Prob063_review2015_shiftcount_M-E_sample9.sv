module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

wire [3:0] next_shift = {q[2:0], data};
wire [3:0] next_count = q - 1'b1;

always @(posedge clk) begin
    if (shift_ena)
        q <= next_shift;
    else if (count_ena)
        q <= next_count;
    // else hold (implicit)
end

endmodule