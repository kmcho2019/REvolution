module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg a_prev;  // Stores previous 'a' value

always @(posedge clock) begin
    // Update q first as it affects p
    if (a) begin
        q <= 0;  // Clear q immediately when 'a' is high
    end else if (a_prev) begin
        q <= 1;  // Set q if we saw 'a' high for full cycle
    end
    
    // Update p based on current state
    if (!q) begin
        p <= a;   // p follows 'a' when q is low
    end else begin
        p <= 0;   // p stays 0 when q is high
    end
    
    // Store current 'a' for next cycle
    a_prev <= a;
end

initial begin
    p = 0;
    q = 0;
    a_prev = 0;
end

endmodule