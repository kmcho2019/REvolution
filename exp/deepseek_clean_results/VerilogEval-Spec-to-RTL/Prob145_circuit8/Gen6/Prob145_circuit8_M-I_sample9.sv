module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg a_sync;
reg p_prev;

always @(posedge clock) begin
    a_sync <= a;  // Synchronize a to clock
    p_prev <= p;  // Store previous p value
    
    // p is high when a is high during clock high phase
    p <= a_sync;
end

always @(negedge clock) begin
    // q is set if p was high in previous cycle
    if (p_prev) begin
        q <= 1'b1;
    end
    // q is cleared when a is low during clock low phase
    else if (~a) begin
        q <= 1'b0;
    end
end

endmodule