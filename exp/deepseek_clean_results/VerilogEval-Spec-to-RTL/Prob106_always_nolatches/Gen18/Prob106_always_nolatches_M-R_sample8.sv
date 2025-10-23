module TopModule (
    input clk,             // Added clock for sequential implementation
    input [15:0] scancode,
    output reg left,
    output reg down,
    output reg right,
    output reg up
);

// Sequential implementation with registered outputs
always @(posedge clk) begin
    // Default all outputs to 0
    left <= 1'b0;
    down <= 1'b0;
    right <= 1'b0;
    up <= 1'b0;
    
    // Check for arrow key presses
    case (scancode)
        16'he06b: left <= 1'b1;
        16'he072: down <= 1'b1;
        16'he074: right <= 1'b1;
        16'he075: up <= 1'b1;
        default: ; // All outputs remain 0
    endcase
end

endmodule