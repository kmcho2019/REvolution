module TopModule (
    input  [15:0] scancode,
    output       left,
    output       down,
    output       right,
    output       up
);

    // Internal 2-bit code for arrow direction
    // 0: none, 1: left, 2: down, 3: right, 4: up (using 3 bits to cover 5 values)
    reg [2:0] arrow_code;

    always @* begin
        case (scancode)
            16'he06b: arrow_code = 3'd1; // left
            16'he072: arrow_code = 3'd2; // down
            16'he074: arrow_code = 3'd3; // right
            16'he075: arrow_code = 3'd4; // up
            default:  arrow_code = 3'd0; // none
        endcase
    end

    assign left  = (arrow_code == 3'd1);
    assign down  = (arrow_code == 3'd2);
    assign right = (arrow_code == 3'd3);
    assign up    = (arrow_code == 3'd4);

endmodule