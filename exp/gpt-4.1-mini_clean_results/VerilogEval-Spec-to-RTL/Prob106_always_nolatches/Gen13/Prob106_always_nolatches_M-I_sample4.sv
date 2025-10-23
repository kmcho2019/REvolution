module TopModule (
    input  [15:0] scancode,
    output reg    left,
    output reg    down,
    output reg    right,
    output reg    up
);

    reg [3:0] arrows_onehot;

    always @(*) begin
        arrows_onehot = 4'b0000; // Default no arrow pressed

        case (scancode)
            16'hE06B: arrows_onehot = 4'b1000; // left
            16'hE072: arrows_onehot = 4'b0100; // down
            16'hE074: arrows_onehot = 4'b0010; // right
            16'hE075: arrows_onehot = 4'b0001; // up
            default:  arrows_onehot = 4'b0000; // none
        endcase

        {left, down, right, up} = arrows_onehot;
    end

endmodule