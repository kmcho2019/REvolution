module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

    // PS/2 scancode decoding for arrow keys
    // Extended keys have 0xE0 prefix followed by key code
    assign left  = (scancode == 16'he06b);
    assign down  = (scancode == 16'he072);
    assign right = (scancode == 16'he074);
    assign up    = (scancode == 16'he075);

endmodule