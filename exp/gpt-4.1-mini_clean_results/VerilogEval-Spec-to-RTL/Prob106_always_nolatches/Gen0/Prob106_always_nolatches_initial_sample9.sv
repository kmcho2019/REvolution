module TopModule(
    input  [15:0] scancode,
    output        left,
    output        down,
    output        right,
    output        up
);

    reg left_reg, down_reg, right_reg, up_reg;

    always @(*) begin
        left_reg  = 1'b0;
        down_reg  = 1'b0;
        right_reg = 1'b0;
        up_reg    = 1'b0;

        case (scancode)
            16'hE06B: left_reg  = 1'b1; // left arrow
            16'hE072: down_reg  = 1'b1; // down arrow
            16'hE074: right_reg = 1'b1; // right arrow
            16'hE075: up_reg    = 1'b1; // up arrow
            default: begin
                left_reg  = 1'b0;
                down_reg  = 1'b0;
                right_reg = 1'b0;
                up_reg    = 1'b0;
            end
        endcase
    end

    assign left  = left_reg;
    assign down  = down_reg;
    assign right = right_reg;
    assign up    = up_reg;

endmodule