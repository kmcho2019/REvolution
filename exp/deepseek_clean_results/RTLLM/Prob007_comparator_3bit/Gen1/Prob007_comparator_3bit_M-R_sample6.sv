module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

always @(*) begin
    // Default assignments
    A_greater = 1'b0;
    A_equal = 1'b0;
    A_less = 1'b0;
    
    case ({A, B})
        {3'b000, 3'b000},
        {3'b001, 3'b001},
        {3'b010, 3'b010},
        {3'b011, 3'b011},
        {3'b100, 3'b100},
        {3'b101, 3'b101},
        {3'b110, 3'b110},
        {3'b111, 3'b111}: A_equal = 1'b1;
        
        {3'b001, 3'b000},
        {3'b010, 3'b000}, {3'b010, 3'b001},
        {3'b011, 3'b000}, {3'b011, 3'b001}, {3'b011, 3'b010},
        {3'b100, 3'b000}, {3'b100, 3'b001}, {3'b100, 3'b010}, {3'b100, 3'b011},
        {3'b101, 3'b000}, {3'b101, 3'b001}, {3'b101, 3'b010}, {3'b101, 3'b011}, {3'b101, 3'b100},
        {3'b110, 3'b000}, {3'b110, 3'b001}, {3'b110, 3'b010}, {3'b110, 3'b011}, {3'b110, 3'b100}, {3'b110, 3'b101},
        {3'b111, 3'b000}, {3'b111, 3'b001}, {3'b111, 3'b010}, {3'b111, 3'b011}, {3'b111, 3'b100}, {3'b111, 3'b101}, {3'b111, 3'b110}: A_greater = 1'b1;
        
        default: A_less = 1'b1;
    endcase
end

endmodule