module TopModule (
    input [15:0] scancode,
    output reg left,
    output reg down,
    output reg right,
    output reg up
);

always @(*) begin
    // Default all outputs to 0
    left = 1'b0;
    down = 1'b0;
    right = 1'b0;
    up = 1'b0;
    
    // Only check if it's an extended key (0xe0 prefix)
    if (scancode[15:8] == 8'he0) begin
        case (scancode[7:0])
            8'h6b: left = 1'b1;   // Left arrow
            8'h72: down = 1'b1;   // Down arrow
            8'h74: right = 1'b1;  // Right arrow
            8'h75: up = 1'b1;     // Up arrow
            default: ;            // No arrow key pressed
        endcase
    end
end

endmodule