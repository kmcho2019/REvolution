module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg p_prev;

always @(posedge clock) begin
    p <= a;  // p updates to current 'a' at every clock edge
    q <= p_prev;  // q gets previous cycle's p value
    p_prev <= p;  // store current p for next cycle
end

endmodule