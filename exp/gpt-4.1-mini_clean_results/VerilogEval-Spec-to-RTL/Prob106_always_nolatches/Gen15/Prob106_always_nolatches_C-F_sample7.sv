module TopModule (
    input  [15:0] scancode,
    output        left,
    output        down,
    output        right,
    output        up
);

    wire [3:0] decoded;

    // decoded bits: [3]=left, [2]=down, [1]=right, [0]=up
    assign decoded = (scancode[15:8] == 8'hE0) ? 
                     ( (scancode[7:0] == 8'h6B) ? 4'b1000 :
                       (scancode[7:0] == 8'h72) ? 4'b0100 :
                       (scancode[7:0] == 8'h74) ? 4'b0010 :
                       (scancode[7:0] == 8'h75) ? 4'b0001 :
                       4'b0000 ) :
                     4'b0000;

    assign left  = decoded[3];
    assign down  = decoded[2];
    assign right = decoded[1];
    assign up    = decoded[0];

endmodule