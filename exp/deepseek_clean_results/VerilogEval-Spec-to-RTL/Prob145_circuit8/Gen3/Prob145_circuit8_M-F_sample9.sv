module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg [1:0] p_history;  // Tracks last two p values

always @(posedge clock) begin
    // p simply follows input a on clock edges
    p <= a;
    
    // Update p history (shift register)
    p_history <= {p_history[0], p};
    
    // q is set when p was high for two consecutive cycles
    q <= (p_history == 2'b11);
end

// Reset q when a=1 during non-clock edges
always @(negedge clock) begin
    if (a) begin
        q <= 0;
    end
end

endmodule