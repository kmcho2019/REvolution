module TopModule(
    input  [15:0] scancode,
    output        left,
    output        down,
    output        right,
    output        up
);

    reg left_reg, down_reg, right_reg, up_reg;

    always @(*) begin
        // Default all outputs to 0
        left_reg  = 0;
        down_reg  = 0;
        right_reg = 0;
        up_reg    = 0;

        case (scancode)
            16'he06b: left_reg  = 1;
            16'he072: down_reg  = 1;
            16'he074: right_reg = 1;
            16'he075: up_reg    = 1;
            default: begin
                // no arrow key pressed
            end
        endcase
    end

    assign left  = left_reg;
    assign down  = down_reg;
    assign right = right_reg;
    assign up    = up_reg;

endmodule