module TopModule(
    input [15:0] scancode,
    output reg left,
    output reg down,
    output reg right,
    output reg up
);

    // Decode the scancode to determine which arrow key is pressed
    always @(*) begin
        // Default all outputs to 0
        left = 1'b0;
        down = 1'b0;
        right = 1'b0;
        up = 1'b0;

        case (scancode)
            16'he06b: left = 1'b1;   // Left arrow
            16'he072: down = 1'b1;   // Down arrow
            16'he074: right = 1'b1;  // Right arrow
            16'he075: up = 1'b1;     // Up arrow
            default: begin
                // All outputs remain 0 for any other scancode
            end
        endcase
    end

endmodule