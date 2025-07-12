// Module: TopModule
// Description: A 2-input AND gate implementation using a lookup table approach.
module TopModule(
    input  a,  // First input of the AND gate
    input  b,  // Second input of the AND gate
    output reg out  // Output of the AND gate
);

// Implement a 2-input AND gate using a case statement (lookup table)
always @(*) begin
    case ({a, b})
        2'b00: out = 1'b0;  // When both inputs are 0, output is 0
        2'b01: out = 1'b0;  // When a=0 and b=1, output is 0
        2'b10: out = 1'b0;  // When a=1 and b=0, output is 0
        2'b11: out = 1'b1;  // When both inputs are 1, output is 1
        default: out = 1'b0;  // Default case to handle any unexpected input combinations
    endcase
end

endmodule