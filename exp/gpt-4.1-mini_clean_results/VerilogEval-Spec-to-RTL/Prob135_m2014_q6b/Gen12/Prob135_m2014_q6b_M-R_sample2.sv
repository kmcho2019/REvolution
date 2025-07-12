module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    // next_y1 logic derived directly from y bits and w without explicit decoding
    assign Y1 = (~y[2] & ~y[1] & y[0])                // B (001)
              | ( y[2] & ~y[1] & y[0])                // F (101)
              | (((~y[2] &  y[1] & ~y[0])              // C (010)
                  | ( y[2] & ~y[1] & ~y[0])) & w);     // E (100) & w

endmodule