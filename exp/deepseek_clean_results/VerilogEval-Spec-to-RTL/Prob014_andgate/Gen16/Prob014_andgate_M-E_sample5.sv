module TopModule(
    input  wire a,
    input  wire b,
    output reg out
);
    // Implement AND gate using 2-input LUT approach
    always @(*) begin
        case ({a, b})
            2'b00: out = 1'b0;
            2'b01: out = 1'b0;
            2'b10: out = 1'b0;
            2'b11: out = 1'b1;
            default: out = 1'b0;
        endcase
    end
endmodule