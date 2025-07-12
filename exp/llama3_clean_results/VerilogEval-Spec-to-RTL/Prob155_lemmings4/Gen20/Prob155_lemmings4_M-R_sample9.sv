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

// Define the states of the Lemming
enum logic [1:0] {
    WALKING,
    FALLING,
    DIGGING,
    SPLATTERED
} state, next_state;

// Counter to track the number of clock cycles the Lemming has been falling
reg [4:0] fall_counter;

// Variable to track the walking direction of the Lemming
reg walking_direction;

// State machine module
StateMachine state_machine(
    .clk(clk),
    .areset(areset),
    .bump_left(bump_left),
    .bump_right(bump_right),
    .ground(ground),
    .dig(dig),
    .state(state),
    .next_state(next_state)
);

// Walking module
Walking walking_module(
    .clk(clk),
    .areset(areset),
    .bump_left(bump_left),
    .bump_right(bump_right),
    .dig(dig),
    .ground(ground),
    .state(state),
    .walking_direction(walking_direction),
    .walk_left(walk_left),
    .walk_right(walk_right)
);

// Falling module
Falling falling_module(
    .clk(clk),
    .areset(areset),
    .ground(ground),
    .state(state),
    .fall_counter(fall_counter),
    .aaah(aaah)
);

// Digging module
Digging digging_module(
    .clk(clk),
    .areset(areset),
    .ground(ground),
    .dig(dig),
    .state(state),
    .digging(digging)
);

// Splattered module
Splattered splattered_module(
    .clk(clk),
    .areset(areset),
    .state(state),
    .walk_left(walk_left),
    .walk_right(walk_right),
    .aaah(aaah),
    .digging(digging)
);

// Update the state
always @(posedge areset or posedge clk) begin
    if (areset) begin
        state <= WALKING;
        fall_counter <= 5'b0;
        walking_direction <= 1'b1; // walking left
    end else begin
        state <= next_state;
        if (state == FALLING) begin
            fall_counter <= fall_counter + 1'b1;
        end else begin
            fall_counter <= 5'b0;
        end
    end
end

endmodule

module StateMachine(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    input [1:0] state,
    output reg [1:0] next_state
);

always @(*) begin
    case (state)
        WALKING: begin
            if (~ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left || bump_right) begin
                next_state = WALKING;
            end else begin
                next_state = WALKING;
            end
        end
        FALLING: begin
            if (ground) begin
                if (fall_counter > 5'd20) begin
                    next_state = SPLATTERED;
                end else begin
                    next_state = WALKING;
                end
            end else begin
                next_state = FALLING;
            end
        end
        DIGGING: begin
            if (~ground) begin
                next_state = FALLING;
            end else begin
                next_state = DIGGING;
            end
        end
        SPLATTERED: begin
            next_state = SPLATTERED;
        end
    endcase
end

endmodule

module Walking(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input dig,
    input ground,
    input [1:0] state,
    input walking_direction,
    output reg walk_left,
    output reg walk_right
);

always @(*) begin
    if (state == WALKING) begin
        walk_left = walking_direction;
        walk_right = ~walking_direction;
        if (bump_left || bump_right) begin
            walking_direction <= ~walking_direction;
        end
    end else begin
        walk_left = 1'b0;
        walk_right = 1'b0;
    end
end

endmodule

module Falling(
    input clk,
    input areset,
    input ground,
    input [1:0] state,
    input [4:0] fall_counter,
    output reg aaah
);

always @(*) begin
    if (state == FALLING) begin
        aaah = 1'b1;
    end else begin
        aaah = 1'b0;
    end
end

endmodule

module Digging(
    input clk,
    input areset,
    input ground,
    input dig,
    input [1:0] state,
    output reg digging
);

always @(*) begin
    if (state == DIGGING) begin
        digging = 1'b1;
    end else begin
        digging = 1'b0;
    end
end

endmodule

module Splattered(
    input clk,
    input areset,
    input [1:0] state,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

always @(*) begin
    if (state == SPLATTERED) begin
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b0;
        digging = 1'b0;
    end
end

endmodule