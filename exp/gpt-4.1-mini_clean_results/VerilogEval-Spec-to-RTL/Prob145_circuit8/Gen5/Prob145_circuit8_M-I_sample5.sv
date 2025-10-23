module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

// On rising edge of clock, capture input 'a' into 'p'
always @(posedge clock) begin
    p <= a;
end

// On falling edge of clock, capture current 'p' into 'q'
always @(negedge clock) begin
    q <= p;
end

endmodule