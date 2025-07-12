module TopModule (
    input x,
    input y,
    output reg z
);
    always @* begin
        case ({x,y})
            2'b00: z = 1;  // Default case
            2'b01: z = 0;  // y=1 alone makes z=0
            2'b10: z = 0;  // x=1 alone makes z=0
            2'b11: z = 1;  // Both high makes z=1
        endcase
    end
endmodule