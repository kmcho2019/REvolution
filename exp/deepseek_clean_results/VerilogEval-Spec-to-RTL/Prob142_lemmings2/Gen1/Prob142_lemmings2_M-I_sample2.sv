module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);
    // Define states
    parameter WALK_LEFT = 2'b00;
    parameter WALK_RIGHT = 2'b01;
    parameter FALL_LEFT = 2'b10;
    parameter FALL_RIGHT = 2'b11;
    
    reg [1:0] state, next_state;
    reg [2:0] prev_inputs;
    
    // Input change detection
    wire inputs_changed = (prev_inputs != {bump_left, bump_right, ground});
    
    // State transition logic
    always @(*) begin
        if (!inputs_changed) begin
            next_state = state;  // No change if inputs haven't changed
        end else begin
            case (state)
                WALK_LEFT: begin
                    if (!ground) next_state = FALL_LEFT;
                    else if (bump_left) next_state = WALK_RIGHT;
                    else next_state = WALK_LEFT;
                end
                WALK_RIGHT: begin
                    if (!ground) next_state = FALL_RIGHT;
                    else if (bump_right) next_state = WALK_LEFT;
                    else next_state = WALK_RIGHT;
                end
                FALL_LEFT: next_state = ground ? WALK_LEFT : FALL_LEFT;
                FALL_RIGHT: next_state = ground ? WALK_RIGHT : FALL_RIGHT;
            endcase
        end
    end
    
    // State register and input tracking
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            prev_inputs <= 3'b0;
        end else begin
            state <= next_state;
            prev_inputs <= {bump_left, bump_right, ground};
        end
    end
    
    // Optimized output logic
    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah = state[1];  // FALL states have MSB set
    
endmodule