module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_p_high;

always @(posedge clock) begin
    // Update p based on current 'a'
    p <= a;
    
    // Update q based on previous p state
    if (prev_p_high && p) begin
        q <= ~q;
    end
    
    // Store if p was high in previous cycle
    prev_p_high <= p;
end

endmodule