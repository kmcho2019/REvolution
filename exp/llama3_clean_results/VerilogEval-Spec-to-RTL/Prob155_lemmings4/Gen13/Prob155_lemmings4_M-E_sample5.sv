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
enum logic [1:0] {
    WALKING,
    FALLING,
    DIGGING,
    SPLATTERED
} state, next_state;

reg [4:0] fall_counter;
reg walk_direction;

// Sub-modules
DirectionController direction_controller(
    .clk(clk),
    .areset(areset),
    .bump_left(bump_left),
    .bump_right(bump_right),
    .walk_direction(walk_direction)
);

FallController fall_controller(
    .clk(clk),
    .areset(areset),
    .ground(ground),
    .fall_counter(fall_counter)
);

DigController dig_controller(
    .clk(clk),
    .areset(areset),
    .dig(dig),
    .ground(ground),
    .digging(digging)
);

SplatterController splatter_controller(
    .clk(clk),
    .areset(areset),
    .fall_counter(fall_counter),
    .ground(ground),
    .aaah(aaah)
);

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING;
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
        digging <= 1'b0;
    end else begin
        case (state)
            WALKING: begin
                if (~ground) begin
                    state <= FALLING;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                    digging <= 1'b0;
                end else if (dig && ground) begin
                    state <= DIGGING;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                    digging <= 1'b1;
                end else begin
                    walk_left <= ~walk_direction;
                    walk_right <= walk_direction;
                    aaah <= 1'b0;
                    digging <= 1'b0;
                end
            end
            FALLING: begin
                if (ground) begin
                    if (fall_counter > 5'd20) begin
                        state <= SPLATTERED;
                        walk_left <= 1'b0;
                        walk_right <= 1'b0;
                        aaah <= 1'b0;
                        digging <= 1'b0;
                    end else begin
                        state <= WALKING;
                        walk_left <= ~walk_direction;
                        walk_right <= walk_direction;
                        aaah <= 1'b0;
                        digging <= 1'b0;
                    end
                end else begin
                    fall_counter <= fall_counter + 1'b1;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                    digging <= 1'b0;
                end
            end
            DIGGING: begin
                if (~ground) begin
                    state <= FALLING;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                    digging <= 1'b0;
                end else begin
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                    digging <= 1'b1;
                end
            end
            SPLATTERED: begin
                state <= SPLATTERED;
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b0;
                digging <= 1'b0;
            end
        endcase
    end
end

endmodule

module DirectionController(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_direction
);

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        walk_direction <= 1'b0;
    end else begin
        if (bump_left || bump_right) begin
            walk_direction <= ~walk_direction;
        end
    end
end

endmodule

module FallController(
    input clk,
    input areset,
    input ground,
    output reg [4:0] fall_counter
);

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        fall_counter <= 5'b0;
    end else begin
        if (~ground) begin
            fall_counter <= fall_counter + 1'b1;
        end else begin
            fall_counter <= 5'b0;
        end
    end
end

endmodule

module DigController(
    input clk,
    input areset,
    input dig,
    input ground,
    output reg digging
);

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        digging <= 1'b0;
    end else begin
        if (dig && ground) begin
            digging <= 1'b1;
        end else if (~ground) begin
            digging <= 1'b0;
        end
    end
end

endmodule

module SplatterController(
    input clk,
    input areset,
    input [4:0] fall_counter,
    input ground,
    output reg aaah
);

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        aaah <= 1'b0;
    end else begin
        if (~ground) begin
            aaah <= 1'b1;
        end else if (fall_counter > 5'd20) begin
            aaah <= 1'b0;
        end else begin
            aaah <= 1'b0;
        end
    end
end

endmodule