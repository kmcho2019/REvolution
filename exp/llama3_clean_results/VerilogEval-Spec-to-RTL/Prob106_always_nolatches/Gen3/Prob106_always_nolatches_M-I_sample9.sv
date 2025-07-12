module TopModule(
    input  [15:0] scancode,
    output reg left,
    output reg down,
    output reg right,
    output reg up
);

always @(*) begin
    // Initialize outputs to default (inactive) state
    left = 1'b0;
    down = 1'b0;
    right = 1'b0;
    up = 1'b0;
    
    // Use a case statement for simplicity and readability
    case (scancode)
        16'he06b: left = 1'b1;  // Left arrow key
        16'he072: down = 1'b1; // Down arrow key
        16'he074: right = 1'b1; // Right arrow key
        16'he075: up = 1'b1;    // Up arrow key
        default: ;             // Default case: no action (outputs remain 0)
    endcase
end

endmodule