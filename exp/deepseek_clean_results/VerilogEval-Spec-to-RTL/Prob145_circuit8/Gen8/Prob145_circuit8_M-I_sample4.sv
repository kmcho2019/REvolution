module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg a_prev;  // To detect edges of 'a'

always @(posedge clock) begin
    a_prev <= a;  // Store previous value of a for edge detection
end

// p is set when a rising edge occurs during clock high
always @(posedge clock) begin
    p <= (a & ~a_prev);  // Detect rising edge of a during clock high
end

// q is 1-cycle delayed version of p with async clear
always @(posedge clock or posedge (a & ~clock)) begin
    if (a & ~clock)
        q <= 1'b0;
    else
        q <= p;
end

endmodule