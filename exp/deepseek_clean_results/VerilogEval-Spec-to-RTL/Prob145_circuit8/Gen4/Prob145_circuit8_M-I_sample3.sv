module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg p_prev;

always @(posedge clock) begin
    p_prev <= p;      // Store previous p value
    p <= a;           // p captures 'a' at clock edge
    
    // q is high when p was high last cycle and is low this cycle
    q <= p_prev & ~p;
end

endmodule