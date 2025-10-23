module TopModule (
    input  wire x,
    input  wire y,
    output reg  z
);

always @(*) begin
    case ({x,y})
        2'b00: z = 1'b1;  // both zero
        2'b11: z = 1'b1;  // both one
        default: z = 1'b0; // inputs differ
    endcase
end

endmodule