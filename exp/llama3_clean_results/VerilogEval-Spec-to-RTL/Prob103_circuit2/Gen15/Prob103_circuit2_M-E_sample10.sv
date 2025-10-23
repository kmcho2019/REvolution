// TopModule: A combinational circuit implementing the inverse XOR of inputs a, b, c, and d using a lookup table
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // Use a case statement to implement the lookup table
    always_comb begin
        case ({a, b, c, d})
            4'b0000: q = 1'b1;  // All inputs are 0, output is 1
            4'b0001: q = 1'b0;  // d is 1, output is 0
            4'b0010: q = 1'b0;  // c is 1, output is 0
            4'b0011: q = 1'b1;  // c and d are 1, output is 1
            4'b0100: q = 1'b0;  // b is 1, output is 0
            4'b0101: q = 1'b1;  // b and d are 1, output is 1
            4'b0110: q = 1'b1;  // b and c are 1, output is 1
            4'b0111: q = 1'b0;  // b, c, and d are 1, output is 0
            4'b1000: q = 1'b0;  // a is 1, output is 0
            4'b1001: q = 1'b1;  // a and d are 1, output is 1
            4'b1010: q = 1'b1;  // a and c are 1, output is 1
            4'b1011: q = 1'b0;  // a, c, and d are 1, output is 0
            4'b1100: q = 1'b1;  // a and b are 1, output is 1
            4'b1101: q = 1'b0;  // a, b, and d are 1, output is 0
            4'b1110: q = 1'b0;  // a, b, and c are 1, output is 0
            4'b1111: q = 1'b1;  // All inputs are 1, output is 1
            default: q = 1'b0;  // Default output is 0
        endcase
    end

endmodule