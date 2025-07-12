module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg a_prev;

always @(posedge clock) begin
    a_prev <= a;
    p <= a & ~a_prev;  // Detect rising edge of a
    q <= p;            // q follows p with 1 cycle delay
end

always @(negedge clock) begin
    p <= 0;  // Reset p when clock goes low
    q <= 0;  // Reset q when clock goes low
end

endmodule