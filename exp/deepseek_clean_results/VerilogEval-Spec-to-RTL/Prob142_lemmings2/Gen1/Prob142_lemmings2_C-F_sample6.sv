module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);
    // Define states
    parameter WALK_LEFT = 2'b00;
    parameter WALK_RIGHT = 2'b01;
    parameter FALL_LEFT = 2'b10;
    parameter FALL_RIGHT = 2'b11;
    
    reg [1:0] state, next_state;
    reg [3:0] prev_inputs;
    
    // Input change detection
    wire inputs_changed = (prev_inputs != {bump_left, bump_right, ground});
    
    // State transition logic
    always @(*) begin
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
            FALL_LEFT: begin
                if (ground) next_state = WALK_LEFT;
                else next_state = FALL_LEFT;
            end
            FALL_RIGHT: begin
                if (ground) next_state = WALK_RIGHT;
                else next_state = FALL_RIGHT;
            end
        endcase
    end
    
    // State register with async reset and input change detection
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            prev_inputs <= 0;
        end
        else if (inputs_changed) begin
            state <= next_state;
            prev_inputs <= {bump_left, bump_right, ground};
        end
    end
    
    // Registered outputs for power optimization
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            walk_left <= 1;
            walk_right <= 0;
            aaah <= 0;
        end
        else begin
            walk_left <= (state == WALK_LEFT);
            walk_right <= (state == WALK_RIGHT);
            aaah <= state[1]; // FALL states have MSB=1
        end
    end
    
endmodule