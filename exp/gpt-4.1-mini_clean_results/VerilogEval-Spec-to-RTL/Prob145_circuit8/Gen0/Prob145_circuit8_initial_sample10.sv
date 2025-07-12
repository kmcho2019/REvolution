module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    // p latches 1 when a=1, remains 1 otherwise
    if (a)
        p <= 1'b1;
    else
        p <= p;
end

always @(negedge clock) begin
    // q copies p at falling edge of clock
    q <= p;
end

endmodule