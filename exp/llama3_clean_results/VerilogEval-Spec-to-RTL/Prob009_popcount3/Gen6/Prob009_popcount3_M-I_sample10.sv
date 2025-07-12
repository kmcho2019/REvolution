module TopModule(
    input [2:0] in,
    output [1:0] out
);

    // Directly implement the population count logic to minimize operations
    always @(*) begin
        case(in)
            3'b000: out = 2'b00; // 0 ones
            3'b001, 3'b010, 3'b100: out = 2'b01; // 1 one
            3'b011, 3'b101, 3'b110: out = 2'b10; // 2 ones
            3'b111: out = 2'b11; // 3 ones
        endcase
    end

    // Alternatively, if the target technology supports it, consider using synthesis directives
    // or attributes to further optimize the design for area and power.

endmodule