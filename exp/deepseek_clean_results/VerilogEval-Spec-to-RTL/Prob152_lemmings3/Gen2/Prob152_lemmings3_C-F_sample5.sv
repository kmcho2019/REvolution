module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // One-hot encoded states
    parameter WALK_L = 6'b000001;
    parameter WALK_R = 6'b000010;
    parameter FALL_L = 6'b000100;
    parameter FALL_R = 6'b001000;
    parameter DIG_L  = 6'b010000;
    parameter DIG_R  = 6'b100000;

    reg [5:0] state, next_state;
    reg [3:0] outputs;

    // State transition logic
    always @(*) begin
        case (1'b1)
            state[0]: begin // WALK_L
                if (~ground)      next_state = FALL_L;
                else if (dig)      next_state = DIG_L;
                else if (bump_left) next_state = WALK_R;
                else               next_state = WALK_L;
            end
            state[1]: begin // WALK_R
                if (~ground)       next_state = FALL_R;
                else if (dig)      next_state = DIG_R;
                else if (bump_right) next_state = WALK_L;
                else               next_state = WALK_R;
            end
            state[2]: begin // FALL_L
                if (ground)        next_state = WALK_L;
                else               next_state = FALL_L;
            end
            state[3]: begin // FALL_R
                if (ground)       next_state = WALK_R;
                else               next_state = FALL_R;
            end
            state[4]: begin // DIG_L
                if (~ground)       next_state = FALL_L;
                else              next_state = DIG_L;
            end
            state[5]: begin // DIG_R
                if (~ground)       next_state = FALL_R;
                else              next_state = DIG_R;
            end
            default:               next_state = WALK_L;
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_L;
            outputs <= 4'b1000; // walk_left=1, others=0
        end
        else begin
            state <= next_state;
            // Output register update
            case (1'b1)
                next_state[0]: outputs <= 4'b1000; // WALK_L
                next_state[1]: outputs <= 4'b0100; // WALK_R
                next_state[2]: outputs <= 4'b0010; // FALL_L
                next_state[3]: outputs <= 4'b0010; // FALL_R
                next_state[4]: outputs <= 4'b0001; // DIG_L
                next_state[5]: outputs <= 4'b0001; // DIG_R
                default:       outputs <= 4'b1000; // WALK_L
            endcase
        end
    end

    // Registered outputs
    assign {walk_left, walk_right, aaah, digging} = outputs;

endmodule