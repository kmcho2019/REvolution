module TopModule (
    input  [15:0] scancode,
    output reg    left,
    output reg    down,
    output reg    right,
    output reg    up
);

    // Separate prefix and keycode for clarity and synthesis optimization
    wire prefix_match = (scancode[15:8] == 8'hE0);
    wire [7:0] keycode = scancode[7:0];

    always @* begin
        // Default all outputs to zero to avoid latches
        left  = 1'b0;
        down  = 1'b0;
        right = 1'b0;
        up    = 1'b0;

        // Decode keycode only if prefix matches
        if (prefix_match) begin
            case (keycode)
                8'h6B: left  = 1'b1;  // Left arrow
                8'h72: down  = 1'b1;  // Down arrow
                8'h74: right = 1'b1;  // Right arrow
                8'h75: up    = 1'b1;  // Up arrow
                // No default needed; outputs remain zero
            endcase
        end
    end

endmodule