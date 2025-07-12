module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg a_prev;

always @(posedge clock) begin
    // Update q: set if full cycle of 'a' high, clear if 'a' is high
    q <= (a_prev & a) ? 1 : (a ? 0 : q);
    
    // p follows previous 'a' only when q is low
    p <= q ? 0 : a_prev;
    
    // Store current 'a' for next cycle
    a_prev <= a;
end

endmodule