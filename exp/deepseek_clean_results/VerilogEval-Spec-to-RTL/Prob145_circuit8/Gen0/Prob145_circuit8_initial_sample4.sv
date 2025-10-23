module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    p <= a;      // p gets current value of a on clock edge
    q <= p;      // q gets previous value of p (one cycle delay)
end

endmodule