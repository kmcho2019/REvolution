module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

    // Decode the scancode to determine which arrow key is pressed
    always @(*) begin
        case (scancode)
            16'he06b: begin  // left arrow
                left = 1;
                down = 0;
                right = 0;
                up = 0;
            end
            16'he072: begin  // down arrow
                left = 0;
                down = 1;
                right = 0;
                up = 0;
            end
            16'he074: begin  // right arrow
                left = 0;
                down = 0;
                right = 1;
                up = 0;
            end
            16'he075: begin  // up arrow
                left = 0;
                down = 0;
                right = 0;
                up = 1;
            end
            default: begin    // no arrow key pressed
                left = 0;
                down = 0;
                right = 0;
                up = 0;
            end
        endcase
    end

endmodule