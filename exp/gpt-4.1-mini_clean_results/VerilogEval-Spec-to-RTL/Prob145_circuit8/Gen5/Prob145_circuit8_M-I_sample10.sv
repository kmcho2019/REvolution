module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

// On rising edge: load p with input a
always @(posedge clock) begin
    p <= a;
end

// On falling edge: load q with previous p
always @(negedge clock) begin
    q <= p;
end

endmodule