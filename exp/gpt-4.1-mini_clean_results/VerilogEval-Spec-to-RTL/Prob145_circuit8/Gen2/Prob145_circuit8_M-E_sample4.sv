module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

initial begin
    p = 1'b0;
    q = 1'b0;
end

// Update p on rising edge: p toggles based on a and current q
always @(posedge clock) begin
    p <= a ^ q;
end

// Update q on falling edge: q captures previous p
always @(negedge clock) begin
    q <= p;
end

endmodule