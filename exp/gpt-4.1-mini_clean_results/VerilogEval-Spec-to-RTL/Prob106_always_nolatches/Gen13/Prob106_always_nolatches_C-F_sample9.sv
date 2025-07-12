module TopModule (
    input  [15:0] scancode,
    output       left,
    output       down,
    output       right,
    output       up
);

    // Direction code encoding:
    // 0 = none, 1 = left, 2 = down, 3 = right, 4 = up
    reg [2:0] dir;

    always @(*) begin
        case (scancode)
            16'hE06B: dir = 3'd1; // left
            16'hE072: dir = 3'd2; // down
            16'hE074: dir = 3'd3; // right
            16'hE075: dir = 3'd4; // up
            default:  dir = 3'd0; // none
        endcase
    end

    assign left  = (dir == 3'd1);
    assign down  = (dir == 3'd2);
    assign right = (dir == 3'd3);
    assign up    = (dir == 3'd4);

endmodule