module TopModule (
    input  [15:0] scancode,
    output reg    left,
    output reg    down,
    output reg    right,
    output reg    up
);

    reg [3:0] arrows_onehot;

    always @(*) begin
        case (scancode)
            16'he06b: arrows_onehot = 4'b1000; // left
            16'he072: arrows_onehot = 4'b0100; // down
            16'he074: arrows_onehot = 4'b0010; // right
            16'he075: arrows_onehot = 4'b0001; // up
            default:  arrows_onehot = 4'b0000;
        endcase

        {left, down, right, up} = arrows_onehot;
    end

endmodule