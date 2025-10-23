// Module TopModule implements an XNOR gate using a lookup table (LUT) approach
module TopModule(
    input a,  // Input signal a
    input b,  // Input signal b
    output out // Output signal out
);

// Implement the XNOR logic using a case statement
always @(*) begin
    case ({a, b})
        2'b00: out = 1'b1; // a=0, b=0
        2'b01: out = 1'b0; // a=0, b=1
        2'b10: out = 1'b0; // a=1, b=0
        2'b11: out = 1'b1; // a=1, b=1
        default: out = 1'bx; // Unknown input combination
    endcase
end

endmodule