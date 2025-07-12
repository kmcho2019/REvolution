module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_a;
reg prev_p;

always @(posedge clock or negedge clock) begin
    if (clock) begin
        // Positive edge of clock
        p <= a & ~prev_a;  // Rising edge detection of 'a' during clock high
        prev_a <= a;
        q <= prev_p;       // q is p delayed by one clock cycle
        prev_p <= p;
    end else begin
        // Negative edge of clock
        if (a & ~prev_a) begin
            // Reset condition: rising edge of 'a' during clock low
            p <= 0;
            q <= 0;
        end
        prev_a <= a;
    end
end

initial begin
    p = 0;
    q = 0;
    prev_a = 0;
    prev_p = 0;
end

endmodule