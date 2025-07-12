module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_a;  // To detect rising edges of 'a'
reg p_prev;   // To track p's previous state

always @(posedge clock) begin
    prev_a <= a;
    p_prev <= p;
    
    // p becomes 1 when we see a rising edge on 'a' during clock high
    p <= (a && !prev_a) ? 1'b1 : 
         (p_prev && !a) ? 1'b0 : p;
end

always @(negedge clock) begin
    // q becomes 1 only after p has been 1 for a full cycle
    q <= (p && p_prev) ? 1'b1 : 
         (!p && !p_prev) ? 1'b0 : q;
end

endmodule