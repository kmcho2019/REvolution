module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg [1:0] p_history;
reg a_low_phase;

always @(posedge clock) begin
    // Main state update on rising edge
    if (!q) begin
        p <= a;
    end else begin
        p <= 0;
    end
    
    // Update p history (shift register)
    p_history <= {p_history[0], p};
end

always @(negedge clock) begin
    // Detect 'a' during low phase for q reset
    if (a) begin
        q <= 0;
    end
    
    // Track if we saw 'a' during low phase
    a_low_phase <= a;
end

always @(posedge clock) begin
    // q update logic (delayed by one full cycle)
    if (p_history[1]) begin
        q <= 1;
    end
    
    // Override with immediate reset if needed
    if (a_low_phase) begin
        q <= 0;
    end
end

initial begin
    p = 0;
    q = 0;
    p_history = 2'b00;
    a_low_phase = 0;
end

endmodule