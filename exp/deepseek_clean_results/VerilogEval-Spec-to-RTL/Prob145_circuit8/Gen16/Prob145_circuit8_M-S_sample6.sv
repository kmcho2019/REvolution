module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg a_prev;  // Stores previous 'a' value

always @(clock) begin
    if (a) q <= 0;  // Clear q immediately when 'a' is high
    
    if (!q) begin
        p <= a;      // p follows 'a' when q is low
    end else begin
        p <= 0;      // p stays 0 when q is high
    end
    
    // Set q if we saw 'a' high for full cycle
    if (a_prev && a && !q) begin
        q <= 1;
    end
    
    a_prev <= a;  // Store current 'a' value
end

initial begin
    p = 0;
    q = 0;
    a_prev = 0;
end

endmodule