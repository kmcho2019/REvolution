module TopModule(
    input  [15:0] scancode,
    output reg left,
    output reg down,
    output reg right,
    output reg up
);

assign left  = (scancode == 16'he06b);
assign down  = (scancode == 16'he072);
assign right = (scancode == 16'he074);
assign up    = (scancode == 16'he075);

endmodule