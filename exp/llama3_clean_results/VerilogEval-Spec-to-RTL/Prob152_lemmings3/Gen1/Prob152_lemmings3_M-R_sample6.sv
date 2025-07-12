module TopModule(
    input  logic clk,
    input  logic areset,
    input  logic bump_left,
    input  logic bump_right,
    input  logic ground,
    input  logic dig,
    output logic walk_left,
    output logic walk_right,
    output logic aaah,
    output logic digging
);

// Enumerate the states
typedef enum logic [1:0] {
    WALK_LEFT = 2'b00,
    WALK_RIGHT = 2'b01,
    FALLING = 2'b10,
    DIGGING = 2'b11
} state_t;

// Current state and next state
state_t current_state;

// State transition and output logic
always_comb begin
    case (current_state)
        WALK_LEFT: begin
            if (!ground) begin
                next_state = FALLING;
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b1;
                digging = 1'b0;
            end else if (dig) begin
                next_state = DIGGING;
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b0;
                digging = 1'b1;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
                walk_left = 1'b0;
                walk_right = 1'b1;
                aaah = 1'b0;
                digging = 1'b0;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
                walk_left = 1'b1;
                walk_right = 1'b0;
                aaah = 1'b0;
                digging = 1'b0;
            end else begin
                next_state = WALK_LEFT;
                walk_left = 1'b1;
                walk_right = 1'b0;
                aaah = 1'b0;
                digging = 1'b0;
            end
        end
        WALK_RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b1;
                digging = 1'b0;
            end else if (dig) begin
                next_state = DIGGING;
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b0;
                digging = 1'b1;
            end else if (bump_left) begin
                next_state = WALK_LEFT;
                walk_left = 1'b1;
                walk_right = 1'b0;
                aaah = 1'b0;
                digging = 1'b0;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
                walk_left = 1'b1;
                walk_right = 1'b0;
                aaah = 1'b0;
                digging = 1'b0;
            end else begin
                next_state = WALK_RIGHT;
                walk_left = 1'b0;
                walk_right = 1'b1;
                aaah = 1'b0;
                digging = 1'b0;
            end
        end
        FALLING: begin
            if (ground) begin
                if (current_state == WALK_LEFT) begin
                    next_state = WALK_LEFT;
                    walk_left = 1'b1;
                    walk_right = 1'b0;
                    aaah = 1'b0;
                    digging = 1'b0;
                end else begin
                    next_state = WALK_RIGHT;
                    walk_left = 1'b0;
                    walk_right = 1'b1;
                    aaah = 1'b0;
                    digging = 1'b0;
                end
            end else begin
                next_state = FALLING;
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b1;
                digging = 1'b0;
            end
        end
        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b1;
                digging = 1'b0;
            end else begin
                next_state = DIGGING;
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b0;
                digging = 1'b1;
            end
        end
        default: begin
            next_state = WALK_LEFT;
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
    endcase
end

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= WALK_LEFT;
    end else begin
        current_state <= next_state;
    end
end

endmodule