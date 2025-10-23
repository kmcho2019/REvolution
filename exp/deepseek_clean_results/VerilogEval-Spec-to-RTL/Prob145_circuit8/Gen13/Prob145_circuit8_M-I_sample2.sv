module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_p;  // Stores p from previous cycle for full-cycle detection

always @(posedge clock) begin
    if (!q) begin
        p <= a;  // Only update p when q is 0
    end else begin
        p <= 0;   // Keep p at 0 when q is 1
    end
    
    // Set q if p was high in previous cycle
    if (prev_p) begin
        q <= 1;
    end
    
    prev_p <= p;  // Store current p for next cycle
end

always @(negedge clock) begin
    if (a) begin
        q <= 0;    // Reset q when a=1 at falling edge
        prev_p <= 0;
    end
end

initial begin
    p = 0;
    q = 0;
    prev_p = 0;
end

endmodule