module TopModule(
    input  [15:0] scancode,
    output        left,
    output        down,
    output        right,
    output        up
);

    // Decode the scancode to one of the four arrow key signals
    // If none match, outputs are zero
    reg left_r, down_r, right_r, up_r;

    always @(*) begin
        // Default outputs are zero
        left_r  = 1'b0;
        down_r  = 1'b0;
        right_r = 1'b0;
        up_r    = 1'b0;

        case (scancode)
            16'he06b: left_r  = 1'b1;  // left arrow
            16'he072: down_r  = 1'b1;  // down arrow
            16'he074: right_r = 1'b1;  // right arrow
            16'he075: up_r    = 1'b1;  // up arrow
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