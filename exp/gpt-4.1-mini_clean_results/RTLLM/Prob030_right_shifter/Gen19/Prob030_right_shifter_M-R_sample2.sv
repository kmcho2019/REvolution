module right_shifter (
    input  wire       clk,
    input  wire       d,
    output reg  [7:0] q
);

reg [7:0] next_q;

initial q = 8'b0;

always @(*) begin
    next_q = {d, q[7:1]};
end

always @(posedge clk) begin
    q <= next_q;
end

endmodule