module TopModule (
    input [15:0] scancode,
    output reg left,
    output reg down,
    output reg right,
    output reg up
);

    always @(*) begin
        // Default outputs (all low)
        left = 1'b0;
        down = 1'b0;
        right = 1'b0;
        up = 1'b0;
        
        // Check for arrow key presses
        case (scancode)
            16'he06b: left = 1'b1;    // Left arrow
            16'he072: down = 1'b1;    // Down arrow
            16'he074: right = 1'b1;   // Right arrow
            16'he075: up = 1'b1;      // Up arrow
            default: ;                // No arrow key pressed
        endcase
    end

endmodule