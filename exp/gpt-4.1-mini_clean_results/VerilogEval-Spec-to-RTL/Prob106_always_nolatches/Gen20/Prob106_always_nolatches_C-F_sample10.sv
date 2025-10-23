module TopModule (
    input  [15:0] scancode,
    output       left,
    output       down,
    output       right,
    output       up
);

    // Internal 3-bit code: 0 = none, 1 = left, 2 = down, 3 = right, 4 = up
    reg [2:0] arrow_code;

    always @* begin
        if (scancode[15:8] == 8'hE0) begin
            case (scancode[7:0])
                8'h6B: arrow_code = 3'd1; // left
                8'h72: arrow_code = 3'd2; // down
                8'h74: arrow_code = 3'd3; // right
                8'h75: arrow_code = 3'd4; // up
                default: arrow_code = 3'd0; // none
            endcase
        end else begin
            arrow_code = 3'd0; // no arrow if prefix not matched
        end
    end

    assign left  = (arrow_code == 3'd1);
    assign down  = (arrow_code == 3'd2);
    assign right = (arrow_code == 3'd3);
    assign up    = (arrow_code == 3'd4);

endmodule