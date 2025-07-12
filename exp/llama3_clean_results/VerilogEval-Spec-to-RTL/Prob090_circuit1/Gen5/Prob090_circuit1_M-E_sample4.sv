module TopModule(
    input  a,
    input  b,
    output q
);
    // Using a case statement to implement a lookup table for the AND gate
    always @(*) begin
        case ({a, b})
            2'b00: q = 1'b0;
            2'b01: q = 1'b0;
            2'b10: q = 1'b0;
            2'b11: q = 1'b1;
            default: q = 1'bx; // Default case to handle unexpected inputs
        endcase
    end
endmodule