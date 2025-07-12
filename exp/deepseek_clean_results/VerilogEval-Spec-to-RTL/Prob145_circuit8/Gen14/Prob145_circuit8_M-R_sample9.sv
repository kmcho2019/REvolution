module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg p_prev;

always @(posedge clock) begin
    // Store previous p value for q calculation
    p_prev <= p;
    
    // Reset q if a is high at clock edge
    if (a) begin
        q <= 0;
    end
    // Otherwise update q based on previous p
    else begin
        q <= q | p_prev;
    end
    
    // Update p: follows a when q is 0, else 0
    if (~q) begin
        p <= a;
    end
    else begin
        p <= 0;
    end
end

initial begin
    p = 0;
    q = 0;
    p_prev = 0;
end

endmodule