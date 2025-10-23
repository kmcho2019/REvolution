module TopModule(
    input a,
    input b,
    input c,
    input d,
    output reg q
);

// Implement the combinational logic within an always block
always @(*) begin
    // Directly assign q based on the conditions of a, b, and c
    q = (b || c) || (a && (b || c));
end

endmodule