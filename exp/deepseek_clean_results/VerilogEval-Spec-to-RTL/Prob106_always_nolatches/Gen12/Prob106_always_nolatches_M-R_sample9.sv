module TopModule (
    input [15:0] scancode,
    output reg left,
    output reg down,
    output reg right,
    output reg up
);

always @(*) begin
    // Default outputs (no arrow pressed)
    left = 1'b0;
    down = 1'b0;
    right = 1'b0;
    up = 1'b0;
    
    // Check if it's an extended key (E0 prefix)
    if (scancode[15:8] == 8'he0) begin
        case (scancode[7:0])
            8'h6b: left = 1'b1;
            8'h72: down = 1'b1;
            8'h74: right = 1'b1;
            8'h75: up = 1'b1;
            default: ; // Do nothing (outputs remain 0)
        endcase
    end
end

endmodule