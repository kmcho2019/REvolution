module TopModule(
    input  [2:0] y,
    input  w,
    output Y1
);

assign Y1 = y[1];

// Next-state logic for y[1]
always @(*)
begin
    case ({y, w})
        3'b0000, 3'b0001: Y1 = 0;
        3'b0010: Y1 = 0;
        3'b0011: Y1 = 1;
        3'b0100: Y1 = 1;
        3'b0101: Y1 = 1;
        3'b1000: Y1 = 1;
        3'b1001: Y1 = 0;
        3'b1010: Y1 = 0;
        3'b1011: Y1 = 1;
        3'b1100, 3'b1101, 3'b1110, 3'b1111: Y1 = 1'b0; // undefined states
    endcase
end

endmodule