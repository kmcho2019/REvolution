module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Using a case statement for explicit implementation of the truth table
always @(*)
    case ({x3, x2, x1})
        3'b000: f = 0;
        3'b001: f = 0;
        3'b010: f = 1;
        3'b011: f = 1;
        3'b100: f = 0;
        3'b101: f = 1;
        3'b110: f = 0;
        3'b111: f = 1;
        default: f = 1'bx; // Handling unknown inputs
    endcase

endmodule