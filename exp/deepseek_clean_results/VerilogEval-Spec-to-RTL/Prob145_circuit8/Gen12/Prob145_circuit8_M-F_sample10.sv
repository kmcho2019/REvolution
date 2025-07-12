module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg p_prev;

always @(posedge clock) begin
    if (~q) begin
        p <= a;  // p follows a only when q is 0
    end else begin
        p <= 0;  // p stays 0 when q is 1
    end
    
    // Set q if p was 1 in previous cycle
    q <= q | p_prev;
    p_prev <= p;
end

always @(negedge clock) begin
    // Reset q if a is high during falling edge
    if (a) begin
        q <= 0;
    end
end

initial begin
    p = 0;
    q = 0;
    p_prev = 0;
end

endmodule