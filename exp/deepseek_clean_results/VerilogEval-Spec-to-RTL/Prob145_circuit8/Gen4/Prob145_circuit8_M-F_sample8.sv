module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg p_prev;

always @(posedge clock) begin
    p <= a;          // p mirrors 'a' only on clock edges
    q <= p_prev;     // q follows p with one cycle delay
    p_prev <= p;     // Store previous p value
end

endmodule