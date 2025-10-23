module TopModule(
    input  logic a,
    input  logic b,
    output logic q
);

always @(*) begin
    q = a & b;
end

// Alternatively, using a conditional operator for the same effect:
// assign q = (a == 1) && (b == 1) ? 1 : 0;

endmodule