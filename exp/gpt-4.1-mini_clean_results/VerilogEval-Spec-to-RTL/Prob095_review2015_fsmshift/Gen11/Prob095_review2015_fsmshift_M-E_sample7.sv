module TopModule (
    input  wire clk,
    input  wire reset,      // synchronous active high
    output reg  shift_ena
);

    typedef enum logic [0:0] {IDLE=1'b0, SHIFT_EN=1'b1} state_t;
    state_t state, next_state;

    reg [2:0] cnt;  // counts down from 4 to 0

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= SHIFT_EN;
            cnt <= 3'd4;
        end else begin
            state <= next_state;

            if (state == SHIFT_EN) begin
                if (cnt != 3'd0)
                    cnt <= cnt - 1;
            end else begin
                cnt <= 3'd0;
            end
        end
    end

    // Next state logic
    always @* begin
        case (state)
            IDLE:      next_state = IDLE;
            SHIFT_EN:  next_state = (cnt == 3'd0) ? IDLE : SHIFT_EN;
            default:   next_state = IDLE;
        endcase
    end

    // Output logic
    always @(posedge clk) begin
        if (reset) begin
            shift_ena <= 1'b1;
        end else begin
            case (state)
                SHIFT_EN:  shift_ena <= (cnt != 3'd0);
                default:   shift_ena <= 1'b0;
            endcase
        end
    end

endmodule