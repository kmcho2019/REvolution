module TopModule (
    input [15:0] scancode,
    output reg left,
    output reg down,
    output reg right,
    output reg up
);

    // Define scancode parameters for maintainability
    localparam PREFIX = 8'hE0;
    localparam LEFT   = 8'h6B;
    localparam DOWN   = 8'h72;
    localparam RIGHT  = 8'h74;
    localparam UP     = 8'h75;

    always @(*) begin
        // Default outputs - no key pressed
        left  = 1'b0;
        down  = 1'b0;
        right = 1'b0;
        up    = 1'b0;

        // Check for extended key prefix first
        if (scancode[15:8] == PREFIX) begin
            // Decode specific arrow keys
            case (scancode[7:0])
                LEFT:   left  = 1'b1;
                DOWN:   down  = 1'b1;
                RIGHT:  right = 1'b1;
                UP:     up    = 1'b1;
                default: ; // Other keys ignored
            endcase
        end
    end

endmodule