module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg a_prev;          // Previous value of 'a' for edge detection
reg p_next;          // Next value of p

always @(posedge clock) begin
    // Detect rising edge of 'a' and generate p pulse
    a_prev <= a;
    p <= p_next;
    
    // Generate pulse when we see rising edge on a
    if (a && !a_prev) begin
        p_next <= 1;
    end else begin
        p_next <= 0;
    end
end

always @(negedge clock) begin
    // Capture p's value into q on falling edge
    q <= p;
end

initial begin
    a_prev = 0;
    p = 0;
    q = 0;
    p_next = 0;
end

endmodule