module TopModule (
    input clock,
    input a,
    output p,
    output q
);

reg prev_a = 0;
reg p_reg = 0;
reg q_reg = 0;
reg a_sampled = 0;

// Sample 'a' during low clock phase
always @(negedge clock) begin
    a_sampled <= a;
end

// Main sequential logic
always @(posedge clock) begin
    // Update previous a value
    prev_a <= a;
    
    // Generate p output (pulses high when a rises)
    p_reg <= a & ~prev_a;
    
    // Update q output (remembers if p was ever high)
    if (p_reg) begin
        q_reg <= 1;
    end else if (a_sampled) begin
        q_reg <= 0;
    end
end

// Continuous assignments for outputs
assign p = p_reg;
assign q = q_reg;

endmodule