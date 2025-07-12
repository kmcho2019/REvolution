module TopModule (
    input [15:0] scancode,
    output reg left,
    output reg down,
    output reg right,
    output reg up
);

    // State definitions
    localparam IDLE = 2'b00;
    localparam GOT_E0 = 2'b01;
    localparam GOT_KEY = 2'b10;

    reg [1:0] state;
    reg [7:0] keycode;

    always @(*) begin
        case(state)
            IDLE: begin
                if (scancode[15:8] == 8'he0) begin
                    state = GOT_E0;
                    keycode = scancode[7:0];
                end else begin
                    state = IDLE;
                end
            end
            GOT_E0: begin
                // Check for valid arrow key codes
                case(scancode[7:0])
                    8'h6b: state = GOT_KEY;
                    8'h72: state = GOT_KEY;
                    8'h74: state = GOT_KEY;
                    8'h75: state = GOT_KEY;
                    default: state = IDLE;
                endcase
                keycode = scancode[7:0];
            end
            GOT_KEY: begin
                state = IDLE;
            end
            default: state = IDLE;
        endcase

        // Output logic
        left = (state == GOT_KEY) && (keycode == 8'h6b);
        down = (state == GOT_KEY) && (keycode == 8'h72);
        right = (state == GOT_KEY) && (keycode == 8'h74);
        up = (state == GOT_KEY) && (keycode == 8'h75);
    end

endmodule