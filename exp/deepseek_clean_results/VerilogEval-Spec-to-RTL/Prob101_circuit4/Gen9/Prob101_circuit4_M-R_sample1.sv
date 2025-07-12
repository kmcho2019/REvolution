module TopModule (
    input a,       // Unused input
    input b,       // Primary input
    input c,       // Primary input
    input d,       // Unused input
    output reg q   // Output as reg
);

    always @(*) begin
        case ({b, c})
            2'b00: q = 1'b0;
            2'b01: q = 1'b1;
            2'b10: q = 1'b1;
            2'b11: q = 1'b1;
            default: q = 1'b0;
        endcase
    end

endmodule