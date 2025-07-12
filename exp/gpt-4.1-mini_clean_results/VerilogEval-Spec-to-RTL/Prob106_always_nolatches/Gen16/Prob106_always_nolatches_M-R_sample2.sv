module TopModule (
    input  [15:0] scancode,
    output        left,
    output        down,
    output        right,
    output        up
);

assign left  = (scancode[15:8] == 8'hE0) && (scancode[7:0] == 8'h6B);
assign down  = (scancode[15:8] == 8'hE0) && (scancode[7:0] == 8'h72);
assign right = (scancode[15:8] == 8'hE0) && (scancode[7:0] == 8'h74);
assign up    = (scancode[15:8] == 8'hE0) && (scancode[7:0] == 8'h75);

endmodule