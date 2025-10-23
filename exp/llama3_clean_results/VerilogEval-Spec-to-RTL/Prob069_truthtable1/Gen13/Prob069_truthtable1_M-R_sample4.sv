module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Using a case statement for explicit condition handling
always @(*) begin
    case ({x3, x2, x1})
        3'b000, 3'b001, 3'b100, 3'b110: f = 0;
        3'b010, 3'b011, 3'b101: f = 1;
        default: f = 0; // Default case to handle any unspecified conditions
    endcase
end

endmodule