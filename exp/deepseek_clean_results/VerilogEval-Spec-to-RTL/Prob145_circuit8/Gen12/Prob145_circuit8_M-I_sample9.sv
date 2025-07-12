module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg p_prev;  // Stores p from previous cycle

// Synchronous behavior
always @(posedge clock) begin
    if (~q) begin
        p <= a;  // Sample 'a' only when q is 0
    end else begin
        p <= 0;   // p stays 0 when q is 1
    end
    
    p_prev <= p;  // Store previous p value
    
    // Set q if p was 1 for full cycle
    if (p_prev && ~q) begin
        q <= 1;
    end
end

// Asynchronous reset of q when a=1 during clock low
always @(a or clock) begin
    if (a && ~clock) begin
        q <= 0;
    end
end

initial begin
    p = 0;
    q = 0;
    p_prev = 0;
end

endmodule