module TopModule(
    input  logic a,
    input  logic b,
    output logic q
);
    
// Implement the AND gate logic using an always block
always @(*) begin
    q = a & b;
end

endmodule