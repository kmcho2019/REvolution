module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg [2:0] p_history;  // 3-bit shift register for p history

always @(posedge clock) begin
    // Generate p pulse when a is high during clock high
    p <= a;
    
    // Update p history shift register
    p_history <= {p_history[1:0], p};
end

always @(negedge clock) begin
    // Check for q reset condition: a high while q is high during clock low
    if (q && a) begin
        q <= 1'b0;
    end
    // Set q when we've seen 3 consecutive p pulses
    else if (&p_history) begin
        q <= 1'b1;
    end
end

endmodule