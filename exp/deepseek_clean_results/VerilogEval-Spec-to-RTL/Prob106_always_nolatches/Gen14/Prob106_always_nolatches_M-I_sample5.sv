module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

// Combine outputs into a single 4-bit vector for more compact implementation
wire [3:0] arrow_keys;

assign arrow_keys = 
    (scancode == 16'he06b) ? 4'b1000 : // left
    (scancode == 16'he072) ? 4'b0100 : // down
    (scancode == 16'he074) ? 4'b0010 : // right
    (scancode == 16'he075) ? 4'b0001 : // up
                             4'b0000;  // none

assign {left, down, right, up} = arrow_keys;

endmodule