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

// Define the top-level states
enum logic [1:0] {
    WALKING = 2'b00,
    FALLING = 2'b01,
    DIGGING = 2'b10
} state;

// Define the walking direction
reg walking_left_direction;

// Define the fall counter and splattering logic
reg [4:0] fall_counter;
reg is_splattered;

// Instantiate the fall counter and splattering logic module
FallCounter fall_counter_module(
    .clk(clk),
    .areset(areset),
    .ground(ground),
    .fall_counter(fall_counter),
    .is_splattered(is_splattered)
);

// Define the walking sub-FSM
enum logic [1:0] {
    WALKING_LEFT = 2'b00,
    WALKING_RIGHT = 2'b01
} walking_state;

// Define the falling sub-FSM
enum logic [1:0] {
    FALLING_DOWN = 2'b00,
    SPLATTERING = 2'b01
} falling_state;

// Define the digging sub-FSM
enum logic [1:0] {
    DIGGING_LEFT = 2'b00,
    DIGGING_RIGHT = 2'b01
} digging_state;

// Update the top-level state and sub-states
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING;
        walking_state <= WALKING_LEFT;
        walking_left_direction <= 1'b1;
        fall_counter <= 5'b0;
        is_splattered <= 1'b0;
    end else begin
        case (state)
            WALKING: begin
                if (!ground) begin
                    state <= FALLING;
                end else if (dig) begin
                    state <= DIGGING;
                end else begin
                    case (walking_state)
                        WALKING_LEFT: begin
                            if (bump_left) begin
                                walking_state <= WALKING_RIGHT;
                            end
                        end
                        WALKING_RIGHT: begin
                            if (bump_right) begin
                                walking_state <= WALKING_LEFT;
                            end
                        end
                    endcase
                end
            end
            FALLING: begin
                if (ground) begin
                    if (is_splattered) begin
                        state <= WALKING;
                    end else begin
                        state <= WALKING;
                    end
                end else begin
                    case (falling_state)
                        FALLING_DOWN: begin
                            fall_counter <= fall_counter + 1'b1;
                        end
                        SPLATTERING: begin
                            // Do nothing
                        end
                    endcase
                end
            end
            DIGGING: begin
                if (!ground) begin
                    state <= FALLING;
                end else begin
                    case (digging_state)
                        DIGGING_LEFT: begin
                            // Do nothing
                        end
                        DIGGING_RIGHT: begin
                            // Do nothing
                        end
                    endcase
                end
            end
        endcase
    end
end

// Assign the outputs
always @(*) begin
    if (is_splattered) begin
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b0;
        digging = 1'b0;
    end else begin
        case (state)
            WALKING: begin
                walk_left = (walking_state == WALKING_LEFT) ? 1'b1 : 1'b0;
                walk_right = (walking_state == WALKING_RIGHT) ? 1'b1 : 1'b0;
                aaah = 1'b0;
                digging = 1'b0;
            end
            FALLING: begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b1;
                digging = 1'b0;
            end
            DIGGING: begin
                walk_left = (digging_state == DIGGING_LEFT) ? 1'b1 : 1'b0;
                walk_right = (digging_state == DIGGING_RIGHT) ? 1'b1 : 1'b0;
                aaah = 1'b0;
                digging = 1'b1;
            end
        endcase
    end
end

endmodule

module FallCounter(
    input clk,
    input areset,
    input ground,
    output reg [4:0] fall_counter,
    output reg is_splattered
);

// Update the fall counter and splattering logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        fall_counter <= 5'b0;
        is_splattered <= 1'b0;
    end else begin
        if (!ground) begin
            fall_counter <= fall_counter + 1'b1;
        end else begin
            if (fall_counter > 5'd20) begin
                is_splattered <= 1'b1;
            end
            fall_counter <= 5'b0;
        end
    end
end

endmodule