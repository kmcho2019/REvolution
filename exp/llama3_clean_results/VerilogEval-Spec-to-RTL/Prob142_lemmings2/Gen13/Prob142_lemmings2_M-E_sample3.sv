module DirectionController(
    input bump_left,
    input bump_right,
    input [1:0] current_direction,
    output reg [1:0] next_direction
);

always @(*) begin
    next_direction = current_direction;
    if (bump_left) begin
        next_direction = 2'b01; // turn right
    end else if (bump_right) begin
        next_direction = 2'b00; // turn left
    end
end

endmodule

module StateController(
    input ground,
    input [1:0] current_state,
    input [1:0] direction,
    output reg [1:0] next_state
);

always @(*) begin
    next_state = current_state;
    if (~ground) begin
        case(current_state)
            2'b00: // walking left
                next_state = 2'b10; // falling left
            2'b01: // walking right
                next_state = 2'b11; // falling right
            default: // already falling, do nothing
        endcase
    end else begin
        case(current_state)
            2'b10: // falling left
                next_state = 2'b00; // resume walking left
            2'b11: // falling right
                next_state = 2'b01; // resume walking right
            default: // do nothing, already walking
        endcase
    end
end

endmodule

module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

reg [1:0] state;
reg [1:0] direction;

DirectionController direction_controller(
    .bump_left(bump_left),
    .bump_right(bump_right),
    .current_direction(direction),
    .next_direction(direction)
);

StateController state_controller(
    .ground(ground),
    .current_state(state),
    .direction(direction),
    .next_state(state)
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // reset to walking left
        direction <= 2'b00; // reset to left
    end else begin
        state <= state; // StateController handles state transitions
        if (bump_left || bump_right) begin
            direction <= direction_controller.next_direction;
        end
    end
end

always @(*) begin
    case(state)
        2'b00: // walking left
            begin
                walk_left = 1'b1;
                walk_right = 1'b0;
                aaah = 1'b0;
            end
        2'b01: // walking right
            begin
                walk_left = 1'b0;
                walk_right = 1'b1;
                aaah = 1'b0;
            end
        2'b10: // falling left
            begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b1;
            end
        2'b11: // falling right
            begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b1;
            end
    endcase
end

endmodule