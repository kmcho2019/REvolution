module TopModule (
    input  [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

    reg [3:0] arrows;

    always @(*) begin
        case (scancode)
            16'he06b: arrows = 4'b1000; // left
            16'he072: arrows = 4'b0100; // down
            16'he074: arrows = 4'b0010; // right
            16'he075: arrows = 4'b0001; // up
            default:  arrows = 4'b0000;
        endcase
    end

    assign left  = arrows[3];
    assign down  = arrows[2];
    assign right = arrows[1];
    assign up    = arrows[0];

endmodule