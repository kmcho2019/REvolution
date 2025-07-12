module TopModule(
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

// Enumerate the states of the FSM
enum logic [2:0] {
    IDLE_LEFT = 3'b001,
    IDLE_RIGHT = 3'b010,
    FALLING = 3'b011,
    DIGGING = 3'b100,
    SPLATTERED = 3'b101
} state, next_state;

// Direction the Lemming was walking before it fell or started digging
logic [0:0] direction;

// Count the number of clock cycles the Lemming has been falling
logic [5:0] fall_count;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
        direction <= 1'b0;
        fall_count <= 6'b000000;
    end else begin
        state <= next_state;
        direction <= (state == IDLE_LEFT || state == IDLE_RIGHT) ? (state == IDLE_LEFT) : direction;
        fall_count <= (state == FALLING) ? fall_count + 1'b1 : (state == DIGGING && ground == 1'b0) ? fall_count + 1'b1 : 6'b000000;
    end
end

// Combinational logic
always_comb begin
    next_state = state;
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;

    case (state)
        IDLE_LEFT: begin
            walk_left = 1'b1;
            if (bump_left) next_state = IDLE_RIGHT;
            else if (bump_right) next_state = IDLE_LEFT;
            if (!ground) next_state = FALLING;
            if (dig) next_state = DIGGING;
        end
        IDLE_RIGHT: begin
            walk_right = 1'b1;
            if (bump_left) next_state = IDLE_LEFT;
            else if (bump_right) next_state = IDLE_RIGHT;
            if (!ground) next_state = FALLING;
            if (dig) next_state = DIGGING;
        end
        FALLING: begin
            aaah = 1'b1;
            if (ground && fall_count > 6'd20) next_state = SPLATTERED;
            else if (ground) next_state = (direction == 1'b0) ? IDLE_LEFT : IDLE_RIGHT;
        end
        DIGGING: begin
            digging = 1'b1;
            if (!ground) next_state = FALLING;
        end
        SPLATTERED: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
        default: next_state = IDLE_LEFT;
    endcase
end

endmodule