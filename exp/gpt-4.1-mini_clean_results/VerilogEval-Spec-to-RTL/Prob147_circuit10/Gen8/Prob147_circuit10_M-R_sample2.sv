module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output reg q
);

reg next_state;

always @(*) begin
    // Next state logic
    next_state = (state & ~(a & b)) | (~state & ~a & b);
    // Output logic
    q = state ^ (a & b);
end

always @(posedge clk) begin
    state <= next_state;
end

initial begin
    state = 1'b0;
    q = 1'b0;
end

endmodule