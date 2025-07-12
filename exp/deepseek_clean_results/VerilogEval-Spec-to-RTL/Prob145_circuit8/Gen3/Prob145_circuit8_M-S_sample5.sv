module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg p_prev;

always @(posedge clock) begin
    p <= a;          // p is high when a is high during clock
    q <= p_prev;     // q follows p with one cycle delay
    p_prev <= p;     // Store previous p value
    
    // Reset condition
    if (~a) begin
        p <= 1'b0;
        q <= 1'b0;
    end
end

endmodule