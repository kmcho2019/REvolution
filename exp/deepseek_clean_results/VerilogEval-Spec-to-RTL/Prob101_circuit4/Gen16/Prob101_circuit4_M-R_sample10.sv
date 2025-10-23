module TopModule (
    input a,       // Unused input (interface requirement)
    input b,       // OR input 1
    input c,       // OR input 2
    input d,       // Unused input (interface requirement)
    output reg q   // Output: q = b OR c
);

    always @(*) begin
        case ({a, b, c, d})
            4'b0000: q = 0;
            4'b0001: q = 0;
            4'b0010: q = 1;
            4'b0011: q = 1;
            4'b0100: q = 1;
            4'b0101: q = 1;
            4'b0110: q = 1;
            4'b0111: q = 1;
            4'b1000: q = 0;
            4'b1001: q = 0;
            4'b1010: q = 1;
            4'b1011: q = 1;
            4'b1100: q = 1;
            4'b1101: q = 1;
            4'b1110: q = 1;
            4'b1111: q = 1;
            default: q = 0; // For completeness
        endcase
    end

    // Implementation note:
    // Output follows q = b OR c pattern as in original
    // All case items explicitly shown for documentation
    // Unused inputs a and d remain in interface but don't affect output
endmodule