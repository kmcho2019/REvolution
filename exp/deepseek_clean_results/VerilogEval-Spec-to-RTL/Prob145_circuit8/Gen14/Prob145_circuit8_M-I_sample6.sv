module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg p_prev;  // Stores p value from previous cycle

always @(posedge clock) begin
    if (~q) begin
        p <= a;  // p follows a only when q is 0
    end else begin
        p <= 0;  // p is 0 when q is 1
    end
    
    // q becomes 1 if p was 1 in previous full cycle
    q <= (q | p_prev) & ~(a & ~clock);
    p_prev <= p;
end

always @(negedge clock) begin
    // Reset q immediately when a is high at falling edge
    if (a) begin
        q <= 0;
    end
end

endmodule