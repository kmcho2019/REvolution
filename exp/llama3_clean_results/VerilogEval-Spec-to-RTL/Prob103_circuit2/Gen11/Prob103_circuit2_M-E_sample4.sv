// TopModule: A combinational circuit implementing the inverse XOR of inputs a, b, c, and d using a lookup table approach
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // Define the lookup table
    // For each possible input combination, specify the output
    always @(*) begin
        case ({a, b, c, d})
            4'b0000: q = 1'b1;  // a=0, b=0, c=0, d=0 -> q=1
            4'b0001: q = 1'b0;  // a=0, b=0, c=0, d=1 -> q=0
            4'b0010: q = 1'b0;  // a=0, b=0, c=1, d=0 -> q=0
            4'b0011: q = 1'b1;  // a=0, b=0, c=1, d=1 -> q=1
            4'b0100: q = 1'b0;  // a=0, b=1, c=0, d=0 -> q=0
            4'b0101: q = 1'b1;  // a=0, b=1, c=0, d=1 -> q=1
            4'b0110: q = 1'b1;  // a=0, b=1, c=1, d=0 -> q=1
            4'b0111: q = 1'b0;  // a=0, b=1, c=1, d=1 -> q=0
            4'b1000: q = 1'b0;  // a=1, b=0, c=0, d=0 -> q=0
            4'b1001: q = 1'b1;  // a=1, b=0, c=0, d=1 -> q=1
            4'b1010: q = 1'b1;  // a=1, b=0, c=1, d=0 -> q=1
            4'b1011: q = 1'b0;  // a=1, b=0, c=1, d=1 -> q=0
            4'b1100: q = 1'b1;  // a=1, b=1, c=0, d=0 -> q=1
            4'b1101: q = 1'b0;  // a=1, b=1, c=0, d=1 -> q=0
            4'b1110: q = 1'b0;  // a=1, b=1, c=1, d=0 -> q=0
            4'b1111: q = 1'b1;  // a=1, b=1, c=1, d=1 -> q=1
            default: q = 1'b0;  // Default case
        endcase
    end

endmodule