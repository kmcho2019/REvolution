module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg a_prev;

always @(posedge clock) begin
    a_prev <= a;
    p <= a_prev;
    q <= p;
end

initial begin
    p = 0;
    q = 0;
    a_prev = 0;
end

endmodule