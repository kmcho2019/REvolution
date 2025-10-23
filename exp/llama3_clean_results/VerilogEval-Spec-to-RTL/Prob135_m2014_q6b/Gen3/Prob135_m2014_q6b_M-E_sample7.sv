module TopModule(
    input [2:0] y,
    input w,
    output reg Y1
);

reg [1:0] next_y1 [3:0];

initial begin
    next_y1[0] = (w == 1'b0) ? 1'b0 : 1'b0; // State A
    next_y1[1] = (w == 1'b0) ? 1'b0 : 1'b1; // State B
    next_y1[2] = (w == 1'b0) ? 1'b1 : 1'b1; // State C
    next_y1[3] = (w == 1'b0) ? 1'b1 : 1'b0; // State D
    next_y1[4] = (w == 1'b0) ? 1'b1 : 1'b1; // State E
    next_y1[5] = (w == 1'b0) ? 1'b0 : 1'b1; // State F
end

always @(y, w)
begin
    case (y)
        3'b000: Y1 = (w == 1'b0) ? 1'b0 : 1'b0; // State A
        3'b001: Y1 = (w == 1'b0) ? 1'b0 : 1'b1; // State B
        3'b010: Y1 = (w == 1'b0) ? 1'b1 : 1'b1; // State C
        3'b011: Y1 = (w == 1'b0) ? 1'b1 : 1'b0; // State D
        3'b100: Y1 = (w == 1'b0) ? 1'b1 : 1'b1; // State E
        3'b101: Y1 = (w == 1'b0) ? 1'b0 : 1'b1; // State F
    endcase
end

endmodule