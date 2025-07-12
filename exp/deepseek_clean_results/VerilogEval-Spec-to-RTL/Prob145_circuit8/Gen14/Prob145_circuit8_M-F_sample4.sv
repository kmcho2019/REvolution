module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg p_prev;

always @(posedge clock) begin
    // Update p based on current state
    if (q) begin
        p <= 0;  // p stays 0 when q is 1
    end else begin
        p <= a;  // p follows a when q is 0
    end
    
    // Update q based on previous p and current a
    if (a) begin
        q <= 0;  // reset q if a is 1
    end else begin
        q <= p_prev;  // set q if p was 1 in previous cycle
    end
    
    // Store current p for next cycle
    p_prev <= p;
end

initial begin
    p = 1'b0;
    q = 1'b0;
    p_prev = 1'b0;
end

endmodule