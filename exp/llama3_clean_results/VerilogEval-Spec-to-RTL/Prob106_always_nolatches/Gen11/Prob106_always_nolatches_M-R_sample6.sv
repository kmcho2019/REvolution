module TopModule(
    input  [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

assign left   = (scancode == 16'he06b)? 1'b1 : 1'b0;
assign down  = (scancode == 16'he072)? 1'b1 : 1'b0;
assign right = (scancode == 16'he074)? 1'b1 : 1'b0;
assign up    = (scancode == 16'he075)? 1'b1 : 1'b0;

endmodule