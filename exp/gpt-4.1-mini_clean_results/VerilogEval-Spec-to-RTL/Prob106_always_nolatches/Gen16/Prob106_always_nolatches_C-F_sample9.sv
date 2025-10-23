module TopModule (
    input  [15:0] scancode,
    output reg    left,
    output reg    down,
    output reg    right,
    output reg    up
);

    // Extract prefix and keycode bytes for clarity and possible optimization
    wire prefix_match = (scancode[15:8] == 8'hE0);
    wire [7:0] keycode = scancode[7:0];

    always @* begin
        // Default outputs low to avoid latches and minimize switching
        left  = 1'b0;
        down  = 1'b0;
        right = 1'b0;
        up    = 1'b0;

        // Decode only if prefix matches 0xE0
        if (prefix_match) begin
            case (keycode)
                8'h6B: left  = 1'b1;
                8'h72: down  = 1'b1;
                8'h74: right = 1'b1;
                8'h75: up    = 1'b1;
                // No default needed; outputs remain zero
            endcase
        end
    end

endmodule