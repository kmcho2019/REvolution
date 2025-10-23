module TopModule(
    input  a,
    input  b,
    output out
);

    // Novel XNOR implementation using a case statement (LUT approach)
    always @(*) begin
        case ({a, b})
            2'b00: out = 1'b1;
            2'b01: out = 1'b0;
            2'b10: out = 1'b0;
            2'b11: out = 1'b1;
            default: out = 1'bx; // Default case for invalid inputs
        endcase
    end

endmodule