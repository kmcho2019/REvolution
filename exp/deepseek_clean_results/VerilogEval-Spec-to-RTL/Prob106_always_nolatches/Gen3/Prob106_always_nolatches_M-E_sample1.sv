module TopModule (
    input [15:0] scancode,
    output reg left,
    output reg down,
    output reg right,
    output reg up
);

    reg [15:0] prev_scancode;
    reg scancode_changed;

    always @(*) begin
        // Edge detection for scancode changes
        scancode_changed = (prev_scancode != scancode);
        
        // Default outputs
        left = 1'b0;
        down = 1'b0;
        right = 1'b0;
        up = 1'b0;

        // Only evaluate when scancode changes
        if (scancode_changed) begin
            case (scancode)
                16'he06b: left = 1'b1;
                16'he072: down = 1'b1;
                16'he074: right = 1'b1;
                16'he075: up = 1'b1;
                default: begin
                    left = 1'b0;
                    down = 1'b0;
                    right = 1'b0;
                    up = 1'b0;
                end
            endcase
            prev_scancode <= scancode;  // Update previous scancode
        end
    end

endmodule