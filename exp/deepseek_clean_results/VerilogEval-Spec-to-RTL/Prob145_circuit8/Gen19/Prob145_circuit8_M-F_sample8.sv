module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg a_sync;          // Synchronized version of 'a'
reg a_prev;          // Previous value of 'a' for edge detection
reg reset_flag;      // Flag for reset condition
reg a_low_phase;     // Captures 'a' during clock low phase

// Capture 'a' during clock low phase for reset condition
always @(negedge clock) begin
    a_low_phase <= a;
end

// Synchronize signals and detect edges
always @(posedge clock) begin
    a_sync <= a;
    a_prev <= a_sync;
    reset_flag <= a_low_phase;
    
    if (reset_flag) begin
        p <= 0;
        q <= 0;
    end
    else begin
        // Detect rising edge of 'a' during clock high
        if (a_sync && ~a_prev) begin
            p <= 1;
            if (~q) begin
                q <= p;  // q will be set in next cycle
            end
        end
        else begin
            p <= 0;
        end
        
        // q remains high once set until reset
        if (q && p) begin
            q <= 1;
        end
    end
end

initial begin
    p = 0;
    q = 0;
    a_sync = 0;
    a_prev = 0;
    reset_flag = 0;
    a_low_phase = 0;
end

endmodule