module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg a_prev;

always @(posedge clock) begin
    a_prev <= a;     // Store previous a value
    p <= a_prev;     // p follows a with one cycle delay
    q <= p;          // q follows p with one cycle delay
    
    // Special case: q resets when a is low during clock edge
    if (~a) begin
        q <= 1'b0;
    end
end

endmodule