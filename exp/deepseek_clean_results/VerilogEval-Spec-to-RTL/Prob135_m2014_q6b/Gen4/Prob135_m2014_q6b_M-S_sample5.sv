module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

// Next-state logic for y[1]
reg y1_next;
always @(*) begin
    case (y)
        3'b000: y1_next = 1'b0;  // A -> A/B, both have y[1]=0
        3'b001: y1_next = 1'b1;  // B -> C/D, both have y[1]=1
        3'b010: y1_next = w ? 1'b1 : 1'b1;  // C -> D/E, both have y[1]=1
        3'b011: y1_next = w ? 1'b0 : 1'b1;  // D -> A/F, y[1]=0/1
        3'b100: y1_next = w ? 1'b1 : 1'b0;  // E -> D/E, y[1]=1/0
        3'b101: y1_next = w ? 1'b1 : 1'b0;  // F -> D/C, y[1]=1/0
        default: y1_next = 1'b0;
    endcase
end

assign Y1 = y[1];

endmodule