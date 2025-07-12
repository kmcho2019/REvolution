module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg p_prev;

always @(posedge clock) begin
    p_prev <= p;  // Store previous p value
    
    // Update p: follows 'a' when q is 0
    p <= a & ~q;
    
    // Update q: becomes 1 if p was 1 in previous cycle
    // resets to 0 if a is 1
    if (a) begin
        q <= 0;
    end
    else begin
        q <= p_prev;
    end
end

initial begin
    p = 0;
    q = 0;
    p_prev = 0;
end

endmodule