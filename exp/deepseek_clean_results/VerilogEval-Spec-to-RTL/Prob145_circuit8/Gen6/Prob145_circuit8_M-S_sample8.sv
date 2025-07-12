module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    p <= a;
    q <= p;
end

initial begin
    p = 0;
    q = 0;
end

endmodule