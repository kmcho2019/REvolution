module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

// p is high when 'a' is high during clock high phase
assign p = a & clock;

// q takes p's value at falling edge of clock
always @(negedge clock) begin
    q <= p;
end

initial begin
    p = 1'b0;
    q = 1'b0;
end

endmodule