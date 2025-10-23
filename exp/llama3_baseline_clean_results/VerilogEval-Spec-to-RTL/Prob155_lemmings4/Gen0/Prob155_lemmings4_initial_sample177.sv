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

// Define states
enum logic [2:0] {
    WALK_LEFT = 3'b001,
    WALK_RIGHT = 3'b010,
    FALLING = 3'b011,
    DIGGING = 3'b100,
    SPLATTERED = 3'b101
} state, next_state;

// Define fall counter
logic [5:0] fall_counter;
logic [5:0] next_fall_counter;

// Combinational logic for next state and outputs
always_comb begin
    next_state = state;
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;

    case(state)
        WALK_LEFT: begin
            if (~ground) begin
                next_state = FALLING;
            end else if (bump_right) begin
                next_state = WALK_RIGHT;
            end else if (dig) begin
                next_state = DIGGING;
            end else begin
                walk_left = 1'b1;
            end
        end
        WALK_RIGHT: begin
            if (~ground) begin
                next_state = FALLING;
            end else if (bump_left) begin
                next_state = WALK_LEFT;
            end else if (dig) begin
                next_state = DIGGING;
            end else begin
                walk_right = 1'b1;
            end
        end
        FALLING: begin
            if (ground) begin
                if (fall_counter > 20) begin
                    next_state = SPLATTERED;
                end else if (state == WALK_LEFT) begin
                    next_state = WALK_LEFT;
                    walk_left = 1'b1;
                end else begin
                    next_state = WALK_RIGHT;
                    walk_right = 1'b1;
                end
            end
            aaah = 1'b1;
        end
        DIGGING: begin
            if (~ground) begin
                next_state = FALLING;
            end else begin
                digging = 1'b1;
            end
        end
        SPLATTERED: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
    endcase
end

// Sequential logic for state and fall counter
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        fall_counter <= 6'b0;
    end else begin
        state <= next_state;
        if (state == FALLING) begin
            fall_counter <= fall_counter + 1;
        end else begin
            fall_counter <= 6'b0;
        end
    end
end

endmodule