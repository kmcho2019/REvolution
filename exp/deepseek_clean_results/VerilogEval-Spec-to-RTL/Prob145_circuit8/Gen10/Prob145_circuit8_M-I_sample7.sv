module TopModule (
    input clock,
    input a,
    output reg p = 0,
    output reg q = 0
);

reg prev_p = 0;

always @(*) begin
    if (clock) begin
        p = a;  // Transparent latch behavior when clock is high
    end
    // else p maintains its value
end

always @(posedge clock) begin
    prev_p <= p;  // Store p value at the end of clock high period
end

always @(negedge clock) begin
    q <= prev_p;  // Update q at the end of clock high period
end

endmodule