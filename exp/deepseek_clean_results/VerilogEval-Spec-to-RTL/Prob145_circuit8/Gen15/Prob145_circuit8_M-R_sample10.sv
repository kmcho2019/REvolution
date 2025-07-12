module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg p_prev;  // Stores p value at falling edge

// Rising edge behavior
always @(posedge clock) begin
    if (!q) begin
        p <= a;  // Sample 'a' when q is low
    end else begin
        p <= 0;   // Keep p low when q is high
    end
    
    // Set q if p was high for full cycle
    if (p_prev && p) begin
        q <= 1;
    end
end

// Falling edge behavior
always @(negedge clock) begin
    p_prev <= p;  // Store p value at falling edge
    
    // Clear q if 'a' is high at falling edge
    if (a) begin
        q <= 0;
    end
end

initial begin
    p = 0;
    q = 0;
    p_prev = 0;
end

endmodule