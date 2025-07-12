module TopModule (
    input  [15:0] scancode,
    output       left,
    output       down,
    output       right,
    output       up
);

    reg [3:0] arrow_onehot;

    always @* begin
        case (scancode)
            16'hE06B: arrow_onehot = 4'b1000; // left
            16'hE072: arrow_onehot = 4'b0100; // down
            16'hE074: arrow_onehot = 4'b0010; // right
            16'hE075: arrow_onehot = 4'b0001; // up
            default:  arrow_onehot = 4'b0000;
        endcase
    end

    assign left  = arrow_onehot[3];
    assign down  = arrow_onehot[2];
    assign right = arrow_onehot[1];
    assign up    = arrow_onehot[0];

endmodule