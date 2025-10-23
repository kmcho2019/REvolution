module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_a;  // Previous value of a for edge detection
reg p_delay; // Delayed version of p for q generation

always @(posedge clock) begin
    prev_a <= a;
    
    // p logic: set on rising edge of a, clear next cycle
    if (a && !prev_a) begin
        p <= 1'b1;
    end else begin
        p <= 1'b0;
    end
    
    // q logic: set when p was high in previous cycle
    p_delay <= p;
    if (p_delay) begin
        q <= 1'b1;
    end else if (a && !prev_a) begin
        q <= 1'b0;
    end
end

endmodule