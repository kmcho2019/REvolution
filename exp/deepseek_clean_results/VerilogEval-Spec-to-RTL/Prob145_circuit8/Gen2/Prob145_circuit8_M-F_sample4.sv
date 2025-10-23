module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg a_prev;
reg p_prev;

always @(posedge clock) begin
    a_prev <= a;  // Store previous value of a
    
    // Detect rising edge of a and set p for one cycle
    p <= (~a_prev && a);
    
    // Set q one cycle after p was high
    q <= (p_prev && ~(~a_prev && a)) ? 1'b1 : 
         (q && (clock || ~(~a && a_prev))) ? q : 1'b0;
    
    p_prev <= p;  // Store previous p value
end

// Asynchronous reset when a falls without clock
always @(negedge a) begin
    if (~clock) begin
        p <= 1'b0;
        q <= 1'b0;
    end
end

endmodule