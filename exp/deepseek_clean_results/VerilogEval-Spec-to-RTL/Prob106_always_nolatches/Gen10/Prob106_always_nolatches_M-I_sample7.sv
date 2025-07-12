module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

    reg [3:0] arrow_keys;
    
    always @(*) begin
        if (scancode[15:8] == 8'he0) begin
            case (scancode[7:0])
                8'h6b: arrow_keys = 4'b1000; // left
                8'h72: arrow_keys = 4'b0100; // down
                8'h74: arrow_keys = 4'b0010; // right
                8'h75: arrow_keys = 4'b0001; // up
                default: arrow_keys = 4'b0000;
            endcase
        end else begin
            arrow_keys = 4'b0000;
        end
    end

    assign {left, down, right, up} = arrow_keys;

endmodule