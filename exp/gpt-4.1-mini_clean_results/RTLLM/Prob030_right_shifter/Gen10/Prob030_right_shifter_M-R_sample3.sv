module right_shifter (
    input wire clk,
    input wire d,
    output reg [7:0] q
);

initial q = 8'b0;

reg [7:0] next_q;

always @(*) begin
    next_q = q >> 1;
    next_q[7] = d;
end

always @(posedge clk) begin
    q <= next_q;
end

endmodule