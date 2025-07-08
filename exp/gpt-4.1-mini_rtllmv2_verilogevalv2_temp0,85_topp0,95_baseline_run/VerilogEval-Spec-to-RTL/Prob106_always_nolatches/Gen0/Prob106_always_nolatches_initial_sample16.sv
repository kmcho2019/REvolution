module TopModule (
    input  [15:0] scancode,
    output        left,
    output        down,
    output        right,
    output        up
);

    reg left_r, down_r, right_r, up_r;

    always @(*) begin
        // Default all outputs to zero
        left_r  = 1'b0;
        down_r  = 1'b0;
        right_r = 1'b0;
        up_r    = 1'b0;

        case (scancode)
            16'he06b: left_r  = 1'b1;
            16'he072: down_r  = 1'b1;
            16'he074: right_r = 1'b1;
            16'he075: up_r    = 1'b1;
            default: begin
                // none asserted
            end
        endcase
    end

    assign left  = left_r;
    assign down  = down_r;
    assign right = right_r;
    assign up    = up_r;

endmodule