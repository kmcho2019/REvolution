module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

reg [4:0] pattern_reg; // Stores the sequence pattern

always @(posedge clk) begin
    if (a) begin
        // Reset pattern to output 4 (100) continuously
        pattern_reg <= 5'b10000;
    end else begin
        // Rotate the pattern right
        pattern_reg <= {pattern_reg[0], pattern_reg[4:1]};
    end
end

// Output selection logic
always @(*) begin
    case (1'b1)
        pattern_reg[0]: q = 3'b100; // 4
        pattern_reg[1]: q = 3'b101; // 5
        pattern_reg[2]: q = 3'b110; // 6
        pattern_reg[3]: q = 3'b000; // 0
        pattern_reg[4]: q = 3'b001; // 1
        default: q = 3'b100; // Default to 4
    endcase
end

endmodule