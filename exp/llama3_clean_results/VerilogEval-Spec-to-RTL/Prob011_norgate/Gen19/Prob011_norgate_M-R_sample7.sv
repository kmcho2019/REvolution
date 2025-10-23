// Refactored TopModule that implements a NOR gate using an always block
module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic out  // Output signal out
);
    always @(*) begin
        out = ~(a | b);  // Implement NOR gate within an always block
    end
endmodule