module TopModule (
    input  [15:0] scancode,
    output       left,
    output       down,
    output       right,
    output       up
);

wire prefix_match = (scancode[15:8] == 8'hE0);

assign left  = prefix_match && (scancode[7:0] == 8'h6B);
assign down  = prefix_match && (scancode[7:0] == 8'h72);
assign right = prefix_match && (scancode[7:0] == 8'h74);
assign up    = prefix_match && (scancode[7:0] == 8'h75);

endmodule