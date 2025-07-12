module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // State encoding
    typedef enum logic [2:0] {
        STATE_0   = 3'd0,  // 0 consecutive 1s
        STATE_1   = 3'd1,  // 1 consecutive 1
        STATE_2   = 3'd2,  // 2 consecutive 1s
        STATE_3   = 3'd3,  // 3 consecutive 1s
        STATE_4   = 3'd4,  // 4 consecutive 1s
        STATE_5   = 3'd5,  // 5 consecutive 1s
        STATE_6   = 3'd6,  // 6 consecutive 1s
        STATE_ERR = 3'd7   // 7+ consecutive 1s (error)
    } state_t;

    state_t state, next_state;

    // State transition logic (combinational)
    always @(*) begin
        case (state)
            STATE_0:   next_state = in ? STATE_1 : STATE_0;
            STATE_1:   next_state = in ? STATE_2 : STATE_0;
            STATE_2:   next_state = in ? STATE_3 : STATE_0;
            STATE_3:   next_state = in ? STATE_4 : STATE_0;
            STATE_4:   next_state = in ? STATE_5 : STATE_0;
            STATE_5:   next_state = in ? STATE_6 : STATE_0;
            STATE_6:   next_state = in ? STATE_ERR : STATE_0;
            STATE_ERR: next_state = in ? STATE_ERR : STATE_0;
            default:   next_state = STATE_0;
        endcase
    end

    // Output generation (sequential)
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            state <= next_state;
            
            // Clear outputs by default
            disc <= 0;
            flag <= 0;
            err <= 0;
            
            // Set outputs based on state transitions
            case (state)
                STATE_5: if (!in) disc <= 1;  // 0111110 pattern
                STATE_6: if (!in) flag <= 1;   // 01111110 pattern
                STATE_ERR: if (!in) err <= 1;  // 01111111... pattern
                default: ;  // No outputs for other states
            endcase
        end
    end

endmodule