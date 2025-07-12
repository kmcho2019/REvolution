module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    reg next_y1_reg;

    always @(*) begin
        // Decode states by pattern matching
        // Default no transition
        next_y1_reg = 1'b0;
        case (y)
            3'b001: next_y1_reg = 1'b1;                 // B
            3'b101: next_y1_reg = 1'b1;                 // F
            3'b010: next_y1_reg = w ? 1'b1 : 1'b0;      // C: w ? 1 : 0
            3'b100: next_y1_reg = w ? 1'b1 : 1'b0;      // E: w ? 1 : 0
            default: next_y1_reg = 1'b0;                 // Other states have next_y1 = 0
        endcase
    end

    assign Y1 = next_y1_reg;

endmodule