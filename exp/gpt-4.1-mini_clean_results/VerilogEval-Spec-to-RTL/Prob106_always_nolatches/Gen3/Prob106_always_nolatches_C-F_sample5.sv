module TopModule(
    input  [15:0] scancode,
    output        left,
    output        down,
    output        right,
    output        up
);

    reg [3:0] dir;

    always @(*) begin
        case (scancode)
            16'he06b: dir = 4'b1000; // left
            16'he072: dir = 4'b0100; // down
            16'he074: dir = 4'b0010; // right
            16'he075: dir = 4'b0001; // up
            default:  dir = 4'b0000;
        endcase
    end

    assign left  = dir[3];
    assign down  = dir[2];
    assign right = dir[1];
    assign up    = dir[0];

endmodule