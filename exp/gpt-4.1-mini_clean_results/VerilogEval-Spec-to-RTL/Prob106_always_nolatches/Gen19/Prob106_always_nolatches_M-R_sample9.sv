module TopModule (
    input  [15:0] scancode,
    output       left,
    output       down,
    output       right,
    output       up
);

    wire [7:0] code = scancode[7:0];
    wire       e0_prefix = (scancode[15:8] == 8'hE0);

    wire left_sig, down_sig, right_sig, up_sig;

    assign {left_sig, down_sig, right_sig, up_sig} = e0_prefix ? (
        (code == 8'h6B) ? 4'b1000 :
        (code == 8'h72) ? 4'b0100 :
        (code == 8'h74) ? 4'b0010 :
        (code == 8'h75) ? 4'b0001 :
                          4'b0000
    ) : 4'b0000;

    assign left  = left_sig;
    assign down  = down_sig;
    assign right = right_sig;
    assign up    = up_sig;

endmodule