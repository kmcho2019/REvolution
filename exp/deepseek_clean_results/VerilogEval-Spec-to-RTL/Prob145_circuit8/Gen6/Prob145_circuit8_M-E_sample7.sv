module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg p_delayed;

always @(posedge clock) begin
    p <= a;              // p gets current 'a' value
    p_delayed <= p;      // Store previous p value
    q <= p_delayed;      // q gets p value from two cycles ago
end

endmodule