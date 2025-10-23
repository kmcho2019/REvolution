module TopModule(
    input  x,
    input  y,
    output z
);

// Implementing the logic using a lookup table (LUT)
always @(*) begin
    case ({x, y})
        2'b00: z = 1'b1;
        2'b01: z = 1'b0;
        2'b10: z = 1'b0;
        2'b11: z = 1'b1;
        default: z = 1'b0;
    endcase
end

endmodule