module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    // On rising edge, p follows input a
    p <= a;
    // q remains unchanged on rising edge
end

always @(negedge clock) begin
    // On falling edge, q takes previous p value
    q <= p;
    // p is reset to 0 on falling edge
    p <= 0;
end

endmodule