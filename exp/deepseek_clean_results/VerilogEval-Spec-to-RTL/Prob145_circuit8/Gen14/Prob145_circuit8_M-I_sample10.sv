module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg p_prev;

always @(posedge clock) begin
    p_prev <= p;  // Store previous p value
    
    if (a) begin
        // When a is high, reset q and update p
        q <= 0;
        p <= a & ~q;
    end
    else begin
        // Normal operation
        p <= a & ~q;
        q <= q | p_prev;
    end
end

initial begin
    p = 0;
    q = 0;
    p_prev = 0;
end

endmodule