module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

// Internal 4-bit output vector
wire [3:0] arrow_keys;

// The ROM lookup table - maps lower byte to 4-bit output (left, down, right, up)
assign arrow_keys = (scancode[15:8] == 8'he0) ? 
    (scancode[7] ? 4'b0000 :  // Filter out high half of ROM (optimization)
        (scancode[6] ? 4'b0000 : // Further optimization
            (scancode[5:0] == 6'b110101 ? 4'b1000 : // 6b (left)
             (scancode[5:0] == 6'b110010 ? 4'b0100 : // 72 (down)
              (scancode[5:0] == 6'b110100 ? 4'b0010 : // 74 (right)
               (scancode[5:0] == 6'b110101 ? 4'b0001 : // 75 (up)
                4'b0000)))))
    : 4'b0000;

// Assign individual outputs from the vector
assign {left, down, right, up} = arrow_keys;

endmodule