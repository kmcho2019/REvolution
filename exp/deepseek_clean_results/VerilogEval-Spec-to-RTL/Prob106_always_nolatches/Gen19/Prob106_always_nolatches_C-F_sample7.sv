module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

// Direct parallel detection of each arrow key condition
wire is_left  = (scancode == 16'he06b);
wire is_down  = (scancode == 16'he072);
wire is_right = (scancode == 16'he074);
wire is_up    = (scancode == 16'he075);

// Direct one-hot output assignment (mutually exclusive by definition)
assign left  = is_left;
assign down  = is_down;
assign right = is_right;
assign up    = is_up;

endmodule