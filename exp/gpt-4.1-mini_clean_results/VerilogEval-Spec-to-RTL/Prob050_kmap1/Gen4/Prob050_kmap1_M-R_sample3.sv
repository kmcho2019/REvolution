module TopModule(
    input  a,
    input  b,
    input  c,
    output reg out
);

// Implement the logic using combinational always block instead of continuous assignment
always @(*) begin
    out = a | b | c;
end

endmodule