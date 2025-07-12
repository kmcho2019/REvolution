module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

// Outputs start as undefined (x) by default

always @(posedge clock) begin
    p <= a ? 1'b1 : 1'b0;
end

always @(negedge clock) begin
    q <= p;
end

endmodule