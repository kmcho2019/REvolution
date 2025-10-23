// TopModule_LUT: A look-up table based combinational circuit implementing the required logic
module TopModule_LUT(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // LUT-based implementation using a case statement
    always @(*) begin
        case ({a, b, c, d})
            4'b0000: q = 1'b1;
            4'b0001: q = 1'b0;
            4'b0010: q = 1'b0;
            4'b0011: q = 1'b1;
            4'b0100: q = 1'b0;
            4'b0101: q = 1'b1;
            4'b0110: q = 1'b1;
            4'b0111: q = 1'b0;
            4'b1000: q = 1'b0;
            4'b1001: q = 1'b1;
            4'b1010: q = 1'b1;
            4'b1011: q = 1'b0;
            4'b1100: q = 1'b1;
            4'b1101: q = 1'b0;
            4'b1110: q = 1'b0;
            4'b1111: q = 1'b1;
            default: q = 1'bx; // Default value for unknown inputs
        endcase
    end

endmodule