// TopModule: A combinational circuit using a lookup table to implement the inverse XOR of inputs a, b, c, and d
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // Define the lookup table as a case statement
    always @(*) begin
        case ({a, b, c, d})
            4'b0000: q = 1'b1;  // Output for input combination 0000
            4'b0001: q = 1'b0;  // Output for input combination 0001
            4'b0010: q = 1'b0;  // Output for input combination 0010
            4'b0011: q = 1'b1;  // Output for input combination 0011
            4'b0100: q = 1'b0;  // Output for input combination 0100
            4'b0101: q = 1'b1;  // Output for input combination 0101
            4'b0110: q = 1'b1;  // Output for input combination 0110
            4'b0111: q = 1'b0;  // Output for input combination 0111
            4'b1000: q = 1'b0;  // Output for input combination 1000
            4'b1001: q = 1'b1;  // Output for input combination 1001
            4'b1010: q = 1'b1;  // Output for input combination 1010
            4'b1011: q = 1'b0;  // Output for input combination 1011
            4'b1100: q = 1'b1;  // Output for input combination 1100
            4'b1101: q = 1'b0;  // Output for input combination 1101
            4'b1110: q = 1'b0;  // Output for input combination 1110
            4'b1111: q = 1'b1;  // Output for input combination 1111
            default: q = 1'bx;  // Default output for unknown input combinations
        endcase
    end

endmodule