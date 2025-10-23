module TopModule (
    input  [15:0] scancode,
    output reg   left,
    output reg   down,
    output reg   right,
    output reg   up
);

    wire prefix_ok = (scancode[15:8] == 8'hE0);
    wire [7:0] keycode = scancode[7:0];

    always @* begin
        // Default all outputs to zero
        left  = 1'b0;
        down  = 1'b0;
        right = 1'b0;
        up    = 1'b0;

        if (prefix_ok) begin
            case (keycode)
                8'h6B: left  = 1'b1;
                8'h72: down  = 1'b1;
                8'h74: right = 1'b1;
                8'h75: up    = 1'b1;
                default: ; // no key pressed
            endcase
        end
    end

endmodule