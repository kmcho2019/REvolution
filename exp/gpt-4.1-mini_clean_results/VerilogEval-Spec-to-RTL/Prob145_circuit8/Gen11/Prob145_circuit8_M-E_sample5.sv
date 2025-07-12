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

// Update p on rising edge of clock
always @(posedge clock) begin
    if (a == 1'b1 || q == 1'b1)
        p <= 1'b1;
    else
        p <= 1'b0;
end

// Update q on falling edge of clock
always @(negedge clock) begin
    q <= p;
end

endmodule