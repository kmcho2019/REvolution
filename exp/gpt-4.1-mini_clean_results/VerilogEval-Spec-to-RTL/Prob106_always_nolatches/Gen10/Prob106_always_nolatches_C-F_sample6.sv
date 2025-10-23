module TopModule (
    input  [15:0] scancode,
    output       left,
    output       down,
    output       right,
    output       up
);

    wire prefix_ok = (scancode[15:8] == 8'hE0);
    wire [7:0] keycode = scancode[7:0];

    reg [3:0] arrow_hot;

    always @(*) begin
        if (prefix_ok) begin
            case (keycode)
                8'h6B: arrow_hot = 4'b1000; // left
                8'h72: arrow_hot = 4'b0100; // down
                8'h74: arrow_hot = 4'b0010; // right
                8'h75: arrow_hot = 4'b0001; // up
                default: arrow_hot = 4'b0000;
            endcase
        end else begin
            arrow_hot = 4'b0000;
        end
    end

    assign left  = arrow_hot[3];
    assign down  = arrow_hot[2];
    assign right = arrow_hot[1];
    assign up    = arrow_hot[0];

endmodule