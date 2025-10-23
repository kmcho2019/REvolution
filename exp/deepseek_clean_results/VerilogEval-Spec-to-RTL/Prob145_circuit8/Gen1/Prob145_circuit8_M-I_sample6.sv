module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg a_prev;

always @(posedge clock) begin
    a_prev <= a;  // Store previous value of a for edge detection
end

always @(*) begin
    // p is high only when clock is high and we detect rising edge of a
    p = clock & a & ~a_prev;
end

always @(posedge clock) begin
    // q becomes 1 one cycle after p was 1
    q <= p;
end

endmodule