module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg [1:0] a_history; // Tracks last two 'a' values
reg q_set;           // Internal flag for q state

always @(posedge clock) begin
    // Update history shift register
    a_history <= {a_history[0], a};
    
    // Update p output
    p <= a;
    
    // Set q when we see two consecutive 'a' highs
    if (a_history == 2'b11) begin
        q_set <= 1'b1;
    end
end

always @(negedge clock) begin
    // Clear q when 'a' is high during low clock phase
    if (a) begin
        q_set <= 1'b0;
    end
end

// Output assignment
always @(*) begin
    q = q_set;
end

initial begin
    a_history = 2'b00;
    q_set = 1'b0;
    p = 1'b0;
end

endmodule