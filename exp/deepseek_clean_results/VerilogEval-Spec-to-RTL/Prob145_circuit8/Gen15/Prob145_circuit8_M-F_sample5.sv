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
    
    // Update q: becomes 1 if p was 1, or stays 1 unless reset
    if (a & q) begin
        q <= 0;  // Reset q only when a is 1 and q was already 1
    end
    else begin
        q <= q | p_prev;  // Set q if p was 1, or maintain current state
    end
end

initial begin
    p = 0;
    q = 0;
    p_prev = 0;
end

endmodule