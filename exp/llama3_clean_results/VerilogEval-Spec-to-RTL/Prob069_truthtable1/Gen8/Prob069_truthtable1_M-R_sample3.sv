module TopModule(
    input x3,
    input x2,
    input x1,
    output reg f
);

// Using an always block with a case statement to express the logic.
// Note that this approach is generally less efficient and more verbose than a simple assign statement for combinational logic.
always @(*) begin
    case ({x3, x2, x1})
        3'b000, 3'b001, 3'b100: f = 1'b0;
        3'b010, 3'b011, 3'b101: f = 1'b1;
        default: f = 1'bx; // This should never happen based on the given inputs.
    endcase
end

endmodule