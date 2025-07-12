module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

wire is_arrow_key = (scancode[15:8] == 8'he0);
wire [3:0] arrow_code;

// Priority encoder for low byte
assign arrow_code[0] = is_arrow_key & (scancode[7:0] == 8'h6b); // left
assign arrow_code[1] = is_arrow_key & (scancode[7:0] == 8'h72); // down
assign arrow_code[2] = is_arrow_key & (scancode[7:0] == 8'h74); // right
assign arrow_code[3] = is_arrow_key & (scancode[7:0] == 8'h75); // up

// One-hot output assignment
assign left  = arrow_code[0];
assign down  = arrow_code[1];
assign right = arrow_code[2];
assign up    = arrow_code[3];

endmodule