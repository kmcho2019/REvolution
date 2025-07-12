module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    p <= clock & a;  // p is high only when both clock and a are high
    q <= p;          // q is p delayed by one clock cycle
end

initial begin
    p = 1'b0;
    q = 1'b0;
end

endmodule