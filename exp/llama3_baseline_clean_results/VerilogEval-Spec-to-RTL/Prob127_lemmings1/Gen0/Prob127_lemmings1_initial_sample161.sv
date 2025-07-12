module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

reg [0:0] state; // internal state signal
reg [0:0] next_state; // next state signal

// define the states
localparam STATE_WALK_LEFT = 0;
localparam STATE_WALK_RIGHT = 1;

// define the outputs based on the current state
assign walk_left = (state == STATE_WALK_LEFT) ? 1'b1 : 1'b0;
assign walk_right = (state == STATE_WALK_RIGHT) ? 1'b1 : 1'b0;

// determine the next state based on the current state and inputs
always @(*) begin
    case(state)
        STATE_WALK_LEFT: begin
            if (bump_left) begin
                next_state = STATE_WALK_RIGHT;
            end else begin
                next_state = STATE_WALK_LEFT;
            end
        end
        STATE_WALK_RIGHT: begin
            if (bump_right) begin
                next_state = STATE_WALK_LEFT;
            end else begin
                next_state = STATE_WALK_RIGHT;
            end
        end
        default: begin
            next_state = STATE_WALK_LEFT;
        end
    endcase
    
    if (bump_left && bump_right) begin
        case(state)
            STATE_WALK_LEFT: begin
                next_state = STATE_WALK_RIGHT;
            end
            STATE_WALK_RIGHT: begin
                next_state = STATE_WALK_LEFT;
            end
        endcase
    end
end

// update the state on the positive edge of the clock
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= STATE_WALK_LEFT;
    end else begin
        if (bump_left && bump_right) begin
            case(state)
                STATE_WALK_LEFT: begin
                    state <= STATE_WALK_RIGHT;
                end
                STATE_WALK_RIGHT: begin
                    state <= STATE_WALK_LEFT;
                end
            endcase
        end else begin
            state <= next_state;
        end
    end
end

endmodule