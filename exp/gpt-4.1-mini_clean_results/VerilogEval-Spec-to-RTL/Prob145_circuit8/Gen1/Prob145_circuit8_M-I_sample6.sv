module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

initial begin
    p = 1'bx;
    q = 1'bx;
end

// On rising edge: p follows a
always @(posedge clock) begin
    p <= a;
    // q holds value
end

// On falling edge: q follows p
always @(negedge clock) begin
    q <= p;
    // p holds value
end

endmodule