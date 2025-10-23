module TopModule (
    input  [15:0] scancode,
    output       left,
    output       down,
    output       right,
    output       up
);

wire upper_match;
wire [7:0] lower_byte;

assign upper_match = (scancode[15:8] == 8'he0);
assign lower_byte = scancode[7:0];

assign left  = upper_match && (lower_byte == 8'h6b);
assign down  = upper_match && (lower_byte == 8'h72);
assign right = upper_match && (lower_byte == 8'h74);
assign up    = upper_match && (lower_byte == 8'h75);

endmodule