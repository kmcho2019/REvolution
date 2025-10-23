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
        // Initialize all outputs to 0
        {left, down, right, up} = 4'b0000;
        
        // Direct pattern matching for arrow keys
        case (scancode)
            16'he06b: left = 1'b1;   // Left arrow
            16'he072: down = 1'b1;   // Down arrow
            16'he074: right = 1'b1;  // Right arrow
            16'he075: up = 1'b1;     // Up arrow
            default: ;               // Other keys ignored
        endcase
    end

endmodule