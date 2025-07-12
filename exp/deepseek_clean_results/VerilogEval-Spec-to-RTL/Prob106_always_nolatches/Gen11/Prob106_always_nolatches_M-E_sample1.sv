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

// Hierarchical detection
wire any_arrow = is_e0 & (is_left | is_down | is_right | is_up);

// Priority encoder style output (though all are mutually exclusive)
assign left = any_arrow & is_left;
assign down = any_arrow & is_down & ~is_left;
assign right = any_arrow & is_right & ~(is_left | is_down);
assign up = any_arrow & is_up & ~(is_left | is_down | is_right);

endmodule