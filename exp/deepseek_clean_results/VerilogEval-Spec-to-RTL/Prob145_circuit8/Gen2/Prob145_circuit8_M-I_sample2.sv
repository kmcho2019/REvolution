module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_a;  // Stores a from previous clock edge
reg [1:0] p_history;  // Tracks last two p values

always @(posedge clock) begin
    // Update p: high if current a=1 and previous a was also 1
    p <= a & prev_a;
    
    // Store current a for next cycle
    prev_a <= a;
    
    // Update p_history shift register
    p_history <= {p_history[0], p};
    
    // Update q: high if p was high for last two cycles
    q <= &p_history;
end

// Reset logic on negative clock edges
always @(negedge clock) begin
    if (a) begin
        p <= 0;
        q <= 0;
        prev_a <= 0;
        p_history <= 0;
    end
end

endmodule