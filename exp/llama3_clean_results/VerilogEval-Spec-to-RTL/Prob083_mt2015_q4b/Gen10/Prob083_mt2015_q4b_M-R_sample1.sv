module TopModule(
    input x,
    input y,
    output z
);

// Utilize a case statement to explicitly define the output z for each possible combination of inputs x and y
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