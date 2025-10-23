module TopModule (
    input clk,                // Clock for sequential logic
    input [15:0] scancode,    // PS/2 scancode input
    output reg left,          // Left arrow output
    output reg down,          // Down arrow output
    output reg right,         // Right arrow output
    output reg up             // Up arrow output
);

    reg [15:0] prev_scancode; // Previous scancode for edge detection
    reg new_data;             // Flag indicating new scancode received

    // Edge detection for new scancode
    always @(posedge clk) begin
        prev_scancode <= scancode;
        new_data <= (scancode != prev_scancode) && (scancode != 16'h0000);
    end

    // Scancode processing with debouncing
    always @(posedge clk) begin
        if (new_data) begin
            // Reset all outputs first
            left <= 1'b0;
            down <= 1'b0;
            right <= 1'b0;
            up <= 1'b0;
            
            // Check for extended key prefix (0xE0)
            if (scancode[15:8] == 8'hE0) begin
                case (scancode[7:0])
                    8'h6B: left <= 1'b1;   // Left arrow
                    8'h72: down <= 1'b1;   // Down arrow
                    8'h74: right <= 1'b1;  // Right arrow
                    8'h75: up <= 1'b1;     // Up arrow
                    default: ;             // Ignore other keys
                endcase
            end
        end
    end

endmodule