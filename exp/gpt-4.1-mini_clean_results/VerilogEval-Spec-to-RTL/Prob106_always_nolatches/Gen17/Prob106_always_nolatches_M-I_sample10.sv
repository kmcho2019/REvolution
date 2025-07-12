module TopModule (
    input  [15:0] scancode,
    output       left,
    output       down,
    output       right,
    output       up
);

    reg [3:0] arrow_code;

    always @(*) begin
        case (scancode)
            16'he06b: arrow_code = 4'b1000; // left
            16'he072: arrow_code = 4'b0100; // down
            16'he074: arrow_code = 4'b0010; // right
            16'he075: arrow_code = 4'b0001; // up
            default:  arrow_code = 4'b0000;
        endcase
    end

    assign left  = arrow_code[3];
    assign down  = arrow_code[2];
    assign right = arrow_code[1];
    assign up    = arrow_code[0];

endmodule