module TopModule (
    input [15:0] scancode,
    output reg [3:0] arrow_keys  // [0]:left, [1]:down, [2]:right, [3]:up
);

always @(*) begin
    arrow_keys = 4'b0000;  // Default all outputs to 0
    
    if (scancode[15:8] == 8'he0) begin
        case (scancode[7:0])
            8'h6b: arrow_keys[0] = 1'b1;  // left
            8'h72: arrow_keys[1] = 1'b1;  // down
            8'h74: arrow_keys[2] = 1'b1;  // right
            8'h75: arrow_keys[3] = 1'b1;  // up
            default: ;
        endcase
    end
end

// Separate outputs for compatibility
assign left  = arrow_keys[0];
assign down  = arrow_keys[1];
assign right = arrow_keys[2];
assign up    = arrow_keys[3];

endmodule