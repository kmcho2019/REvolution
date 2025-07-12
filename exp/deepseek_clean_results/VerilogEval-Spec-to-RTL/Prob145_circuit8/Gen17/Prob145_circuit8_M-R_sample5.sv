module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg a_prev_pos;  // 'a' at previous positive edge
reg a_prev_neg;  // 'a' at previous negative edge

// Positive edge behavior (for p)
always @(posedge clock) begin
    if (!q) begin
        p <= a;  // p follows 'a' only when q=0
    end else begin
        p <= 0;
    end
    
    a_prev_pos <= a;  // Store 'a' at positive edge
    
    // Clear q if 'a' is high at positive edge
    if (a) begin
        q <= 0;
    end
end

// Negative edge behavior (for q)
always @(negedge clock) begin
    a_prev_neg <= a;  // Store 'a' at negative edge
    
    // Set q if we saw 'a'=1 for full cycle (both edges)
    if (a_prev_pos && a_prev_neg && !q) begin
        q <= 1;
    end
    
    // Clear q if 'a' is high at negative edge
    if (a) begin
        q <= 0;
    end
end

initial begin
    p = 0;
    q = 0;
    a_prev_pos = 0;
    a_prev_neg = 0;
end

endmodule