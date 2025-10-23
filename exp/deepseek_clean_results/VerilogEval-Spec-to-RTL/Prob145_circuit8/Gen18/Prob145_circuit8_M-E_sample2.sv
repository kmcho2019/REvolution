module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg a_sync;          // Synchronized version of 'a'
reg a_prev;          // Previous value of 'a' for edge detection
reg reset_condition;  // Reset flag
reg p_delayed;       // Delayed version of p for q generation

// Synchronize 'a' and detect rising edges
always @(posedge clock) begin
    a_sync <= a;
    a_prev <= a_sync;
    
    // Detect reset condition (a high during previous low phase)
    reset_condition <= ~clock & a;
end

// Main output generation
always @(posedge clock) begin
    if (reset_condition) begin
        p <= 0;
        q <= 0;
        p_delayed <= 0;
    end
    else begin
        // p logic: follows rising edges of 'a' when q is 0
        if (~q && a_sync && ~a_prev) begin
            p <= 1;
        end else begin
            p <= 0;
        end
        
        // q logic: delayed version of p
        q <= p_delayed;
        p_delayed <= p;
    end
end

initial begin
    p = 0;
    q = 0;
    a_sync = 0;
    a_prev = 0;
    reset_condition = 0;
    p_delayed = 0;
end

endmodule