module TopModule(
    input  a,
    input  b,
    output out
);

    // Novel XNOR implementation using a lookup table approach
    always @(*)
    begin
        case ({a, b})
            2'b00: out = 1'b1;
            2'b01: out = 1'b0;
            2'b10: out = 1'b0;
            2'b11: out = 1'b1;
            default: out = 1'bx; // This should never happen for 2-bit inputs
        endcase
    end

endmodule