module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg p_prev;  // Stores p's value from previous cycle

// Synchronous logic for p (updates on rising edge)
always @(posedge clock) begin
    p <= a;        // p takes value of a at rising edge
    p_prev <= p;   // Store current p value for next cycle
end

// Asynchronous logic for q (updates when clock is low)
always @(*) begin
    if (~clock) begin
        q = p_prev; // q follows previous p value during clock low
    end
end

endmodule