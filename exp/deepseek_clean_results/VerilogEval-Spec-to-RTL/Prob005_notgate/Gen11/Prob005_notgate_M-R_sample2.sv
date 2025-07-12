// Refactored NOT gate using procedural always block
module TopModule (
    input in,
    output reg out  // Note: output needs to be reg type for procedural assignment
);
    always @(*) begin
        out = ~in;  // Procedural assignment with wildcard sensitivity
    end
endmodule