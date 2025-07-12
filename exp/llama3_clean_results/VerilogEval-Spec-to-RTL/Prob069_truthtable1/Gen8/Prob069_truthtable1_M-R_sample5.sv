module TopModule(
    input x3,
    input x2,
    input x1,
    output reg f
);

always @(*) begin
    case ({x3, x2, x1})
        3'b000, 3'b001, 3'b100: f = 1'b0;
        3'b010, 3'b011, 3'b101: f = 1'b1;
        default: f = 1'b0; // This line is technically redundant given the truth table
    endcase
end

endmodule