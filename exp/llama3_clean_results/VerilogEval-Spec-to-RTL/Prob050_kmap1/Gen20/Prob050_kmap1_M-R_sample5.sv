module TopModule(
    input a,
    input b,
    input c,
    output out
);

always @(*)
    case ({a, b, c})
        3'b000, 3'b001: out = 0;
        3'b010, 3'b011, 3'b100, 3'b101, 3'b110, 3'b111: out = 1;
        default: out = 1'bx; // This line handles any unexpected input combinations
    endcase

endmodule