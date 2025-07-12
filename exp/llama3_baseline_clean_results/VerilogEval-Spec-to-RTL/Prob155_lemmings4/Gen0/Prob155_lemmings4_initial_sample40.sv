module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

// Define the states of the state machine
enum logic [2:0] {WalkingLeft, WalkingRight, Falling, Digging, Splattered} state, next_state;

// Define a register to count the number of clock cycles the Lemming has been falling
logic [5:0] fall_count;

// Define a register to store the direction of the Lemming before it started falling
logic walk_direction;

// Combinational logic to determine the next state
always_comb begin
    next_state = state;
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;

    case(state)
        WalkingLeft: begin
            if (~ground) begin
                next_state = Falling;
                walk_direction = 1'b0;  // 0 for left
            end
            else if (dig) begin
                next_state = Digging;
            end
            else if (bump_right) begin
                next_state = WalkingRight;
            end
            walk_left = 1'b1;
        end

        WalkingRight: begin
            if (~ground) begin
                next_state = Falling;
                walk_direction = 1'b1;  // 1 for right
            end
            else if (dig) begin
                next_state = Digging;
            end
            else if (bump_left) begin
                next_state = WalkingLeft;
            end
            walk_right = 1'b1;
        end

        Falling: begin
            aaah = 1'b1;
            if (ground) begin
                if (fall_count > 20) begin
                    next_state = Splattered;
                end
                else if (walk_direction) begin
                    next_state = WalkingRight;
                end
                else begin
                    next_state = WalkingLeft;
                end
            end
        end

        Digging: begin
            digging = 1'b1;
            if (~ground) begin
                next_state = Falling;
            end
        end

        Splattered: begin
            // Do nothing
        end

        default: begin
            next_state = WalkingLeft;
        end

    endcase
end

// Sequential logic to update the state and count
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WalkingLeft;
        fall_count <= 6'b0;
    end
    else begin
        state <= next_state;
        if (state == Falling) begin
            fall_count <= fall_count + 1'b1;
        end
        else begin
            fall_count <= 6'b0;
        end
    end
end

endmodule