module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    p <= a;      // p captures 'a' at rising edge
    q <= p;      // q follows p with one cycle delay
end

endmodule