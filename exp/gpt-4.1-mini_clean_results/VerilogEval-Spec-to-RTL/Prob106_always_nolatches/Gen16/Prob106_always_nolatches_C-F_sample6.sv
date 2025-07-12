module TopModule (
    input  [15:0] scancode,
    output reg    left,
    output reg    down,
    output reg    right,
    output reg    up
);

    always @(*) begin
        // Default all outputs to 0
        left  = 1'b0;
        down  = 1'b0;
        right = 1'b0;
        up    = 1'b0;

        // Only decode if prefix byte is 0xE0
        if (scancode[15:8] == 8'hE0) begin
            case (scancode[7:0])
                8'h6B: left  = 1'b1;
                8'h72: down  = 1'b1;
                8'h74: right = 1'b1;
                8'h75: up    = 1'b1;
                default: ; // no output asserted
            endcase
        end
    end

endmodule