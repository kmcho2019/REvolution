module TopModule(
    input  [15:0] scancode,
    output  left,
    output  down,
    output  right,
    output  up
);

assign {left, down, right, up} = 
    (scancode == 16'he06b) ? 4'b1000 :
    (scancode == 16'he072)? 4'b0100 :
    (scancode == 16'he074)? 4'b0010 :
    (scancode == 16'he075)? 4'b0001 : 4'b0000;

endmodule