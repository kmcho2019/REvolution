module TopModule(
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

// Define states
typedef enum logic [2:0] {
    WALKING,
    FALLING,
    DIGGING,
    SPLATTERED
} state_t;

state_t current_state;
state_t next_state;

// Define direction
reg walk_dir;

// Define fall counter
reg [4:0] fall_counter;
reg [4:0] next_fall_counter;

// Define splatter flag
reg splatter;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= WALKING;
        walk_dir <= 1'b0;
        fall_counter <= 5'b0;
        splatter <= 1'b0;
    end else begin
        current_state <= next_state;
        walk_dir <= walk_dir;
        fall_counter <= next_fall_counter;
        splatter <= splatter | (next_state == SPLATTERED);
    end
end

// Next state and output logic
always_comb begin
    next_state = current_state;
    next_fall_counter = fall_counter;

    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;

    case (current_state)
        WALKING: begin
            if (~ground) begin
                next_state = FALLING;
                next_fall_counter = 5'b1;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left || bump_right) begin
                walk_dir = ~walk_dir;
            end
            walk_left = walk_dir;
            walk_right = ~walk_dir;
        end
        FALLING: begin
            next_fall_counter = fall_counter + 1'b1;
            if (ground) begin
                if (fall_counter > 5'd20) begin
                    next_state = SPLATTERED;
                end else begin
                    next_state = WALKING;
                    next_fall_counter = 5'b0;
                end
            end
            aaah = 1'b1;
        end
        DIGGING: begin
            if (~ground) begin
                next_state = FALLING;
                next_fall_counter = 5'b1;
            end
            digging = 1'b1;
        end
        SPLATTERED: begin
            // do nothing
        end
    endcase

    if (splatter) begin
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b0;
        digging = 1'b0;
    end
end

endmodule