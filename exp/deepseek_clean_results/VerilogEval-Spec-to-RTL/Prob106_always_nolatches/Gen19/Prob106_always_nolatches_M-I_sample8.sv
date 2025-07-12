module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

// Parallel detection of all conditions
wire is_e0 = (scancode[15:8] == 8'he0);
wire is_left = (scancode[7:0] == 8'h6b);
wire is_down = (scancode[7:0] == 8'h72);
wire is_right = (scancode[7:0] == 8'h74);
wire is_up = (scancode[7:0] == 8'h75);

// Direct output assignment (mutually exclusive cases)
assign left = is_e0 & is_left;
assign down = is_e0 & is_down;
assign right = is_e0 & is_right;
assign up = is_e0 & is_up;

endmodule