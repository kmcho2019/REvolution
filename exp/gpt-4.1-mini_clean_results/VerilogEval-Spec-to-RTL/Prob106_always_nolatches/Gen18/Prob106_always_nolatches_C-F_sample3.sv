module TopModule (
    input  [15:0] scancode,
    output reg    left,
    output reg    down,
    output reg    right,
    output reg    up
);

    // Prefix match indicates extended key (0xE0 prefix)
    wire prefix_match = (scancode[15:8] == 8'hE0);
    // Extract lower byte as keycode for decoding
    wire [7:0] keycode = scancode[7:0];

    always @* begin
        // Default all outputs low to avoid latches and reduce switching
        left  = 1'b0;
        down  = 1'b0;
        right = 1'b0;
        up    = 1'b0;

        // Decode only if prefix matches extended key code 0xE0
        if (prefix_match) begin
            case (keycode)
                8'h6B: left  = 1'b1; // Left arrow
                8'h72: down  = 1'b1; // Down arrow
                8'h74: right = 1'b1; // Right arrow
                8'h75: up    = 1'b1; // Up arrow
                // No default required; outputs remain zero
            endcase
        end
    end

endmodule