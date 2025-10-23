module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

    // One-hot encoded states
    parameter WALK = 3'b001;
    parameter FALL = 3'b010;
    parameter DIG  = 3'b100;

    reg [2:0] state;
    reg direction; // 0=left, 1=right
    reg next_direction;
    reg direction_valid;

    // Combinational next state logic
    always @(*) begin
        next_direction = direction;
        direction_valid = 1'b0;
        
        case (1'b1) // synthesis parallel_case
            state[0]: begin // WALK
                if (!ground) begin
                    state = FALL;
                end
                else if (dig) begin
                    state = DIG;
                end
                else begin
                    state = WALK;
                    // Only process bumps if staying in WALK
                    if (bump_left && !direction) begin
                        next_direction = 1'b1;
                        direction_valid = 1'b1;
                    end
                    else if (bump_right && direction) begin
                        next_direction = 1'b0;
                        direction_valid = 1'b1;
                    end
                end
            end
            
            state[1]: begin // FALL
                state = ground ? WALK : FALL;
            end
            
            state[2]: begin // DIG
                state = ground ? DIG : FALL;
            end
            
            default: state = WALK;
        endcase
    end

    // Sequential logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 1'b0;
            {walk_left, walk_right, aaah, digging} <= 4'b1000;
        end
        else begin
            state <= state;
            if (direction_valid) direction <= next_direction;
            
            // Registered outputs
            walk_left <= (state == WALK) && !direction;
            walk_right <= (state == WALK) && direction;
            aaah <= (state == FALL);
            digging <= (state == DIG);
        end
    end

endmodule