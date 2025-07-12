module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

// One-hot encoded output
wire [3:0] arrow_keys = (scancode[15:8] == 8'he0) ? 
    (scancode[7:0] == 8'h6b ? 4'b1000 :  // left
     scancode[7:0] == 8'h72 ? 4'b0100 :  // down
     scancode[7:0] == 8'h74 ? 4'b0010 :  // right
     scancode[7:0] == 8'h75 ? 4'b0001 :  // up
                              4'b0000) : // no arrow
                         4'b0000;        // no arrow

assign {left, down, right, up} = arrow_keys;

endmodule