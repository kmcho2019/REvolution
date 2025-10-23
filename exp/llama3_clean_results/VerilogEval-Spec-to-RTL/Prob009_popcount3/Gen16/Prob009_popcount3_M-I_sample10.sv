module TopModule(
    input [2:0] in,
    output [1:0] out
);

    // Optimized approach using a conditional statement
    always @(*) begin
        case (in)
            3'b000: out = 2'b00;
            3'b001, 3'b010, 3'b100: out = 2'b01;
            3'b011, 3'b101, 3'b110: out = 2'b10;
            3'b111: out = 2'b11;
        endcase
    end

    // This implementation is chosen for its simplicity, area efficiency, and ease of understanding.
    // It directly calculates the population count of the input vector 'in' and assigns it to 'out'.

endmodule