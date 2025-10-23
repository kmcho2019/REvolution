// Refactored module using an always block for the OR operation.
module TopModule(
    input logic a,  
    input logic b,
    input logic c,
    output logic out  
);

always @(*) begin
    // The logic remains the same, implementing an OR operation.
    out = a | b | c;
end

endmodule