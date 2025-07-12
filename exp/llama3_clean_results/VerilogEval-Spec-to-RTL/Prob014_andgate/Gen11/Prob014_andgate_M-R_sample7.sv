module TopModule(
    input  logic a,
    input  logic b,
    output logic out
);

// Implement a 2-input AND gate using an always block
always @(*) begin
    out = a & b;
end

endmodule