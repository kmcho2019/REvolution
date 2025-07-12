module TopModule (
    input [15:0] scancode,
    output reg left,
    output reg down,
    output reg right,
    output reg up
);

    // PS/2 scancode decoding for arrow keys
    // Extended keys have 0xE0 prefix followed by key code
    always @(*) begin
        // Default outputs (no key pressed)
        left = 1'b0;
        down = 1'b0;
        right = 1'b0;
        up = 1'b0;
        
        // Check if extended key (0xE0 prefix)
        if (scancode[15:8] == 8'hE0) begin
            case (scancode[7:0])
                8'h6B: left = 1'b1;   // Left arrow
                8'h72: down = 1'b1;   // Down arrow
                8'h74: right = 1'b1;  // Right arrow
                8'h75: up = 1'b1;     // Up arrow
                default: ;            // Other keys ignored
            endcase
        end
    end

endmodule