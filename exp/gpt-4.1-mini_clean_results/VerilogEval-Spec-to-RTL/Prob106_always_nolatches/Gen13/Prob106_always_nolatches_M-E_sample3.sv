module TopModule (
    input  [15:0] scancode,
    output       left,
    output       down,
    output       right,
    output       up
);

// Direct comparison of full 16-bit scancode with constants
assign left  = (scancode == 16'he06b);
assign down  = (scancode == 16'he072);
assign right = (scancode == 16'he074);
assign up    = (scancode == 16'he075);

endmodule