module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    state <= q;
end

always @(*) begin
    // next state logic
    q = ( (~state) & ( (b & ~a) | (~b & a) ) ) | ( state & ( (a & b) | (~a & ~b) ) );
end

initial begin
    state = 0;
    q = 0;
end

endmodule