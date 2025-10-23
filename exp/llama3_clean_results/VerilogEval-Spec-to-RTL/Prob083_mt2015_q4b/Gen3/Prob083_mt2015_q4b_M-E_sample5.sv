module TopModule(
    input x,
    input y,
    output z
);

// Define the lookup table as a case statement
always @(*) begin
    case ({x, y})
        2'b00: z = 1'b1; // x=0, y=0
        2'b01: z = 1'b0; // x=0, y=1
        2'b10: z = 1'b0; // x=1, y=0
        2'b11: z = 1'b1; // x=1, y=1
        default: z = 1'b0; // Default case, though it should never be reached
    endcase
end

endmodule