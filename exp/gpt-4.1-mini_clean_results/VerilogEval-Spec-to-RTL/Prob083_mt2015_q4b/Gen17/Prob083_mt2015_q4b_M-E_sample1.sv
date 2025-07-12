module TopModule (
    input  wire x,
    input  wire y,
    output reg  z
);

always @(*) begin
    case ({x,y})
        2'b00: z = 1'b1;  // x=0, y=0 -> z=1
        2'b01: z = 1'b0;  // x=0, y=1 -> z=0
        2'b10: z = 1'b0;  // x=1, y=0 -> z=0
        2'b11: z = 1'b1;  // x=1, y=1 -> z=1
        default: z = 1'b0; // default safety
    endcase
end

endmodule