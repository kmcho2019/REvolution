module TopModule (
    input in1,
    input in2,
    output reg out
);
    // Implement NOR gate using case statement
    always @(*) begin
        case ({in1, in2})
            2'b00: out = 1'b1;  // NOR truth table
            2'b01: out = 1'b0;
            2'b10: out = 1'b0;
            2'b11: out = 1'b0;
            default: out = 1'b0; // Default case (should never occur)
        endcase
    end
endmodule