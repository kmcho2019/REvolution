module TopModule (
    input  [15:0] scancode,
    output reg   left,
    output reg   down,
    output reg   right,
    output reg   up
);

    // Direction encoding:
    // 2'b00: no key
    // 2'b01: left
    // 2'b10: down
    // 2'b11: right
    // up will be handled separately for clarity as it's distinct
    reg [1:0] direction;

    always @* begin
        case (scancode)
            16'hE06B: direction = 2'b01; // left
            16'hE072: direction = 2'b10; // down
            16'hE074: direction = 2'b11; // right
            16'hE075: direction = 2'b00; // up (handle separately)
            default:  direction = 2'b00;
        endcase

        // Initialize all outputs to zero
        left  = 1'b0;
        down  = 1'b0;
        right = 1'b0;
        up    = 1'b0;

        // Decode direction
        case (direction)
            2'b01: left  = 1'b1;
            2'b10: down  = 1'b1;
            2'b11: right = 1'b1;
            default: ; // no output
        endcase

        // Handle up key separately
        if (scancode == 16'hE075)
            up = 1'b1;
    end

endmodule