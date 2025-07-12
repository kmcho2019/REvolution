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

// Define state encoding
localparam WALKING = 2'b00;
localparam FALLING = 2'b01;
localparam DIGGING = 2'b10;
localparam SPLATTERED = 2'b11;

// Define state machine
reg [1:0] state;
reg [4:0] fall_counter;
reg walking_direction;

// Walking module
module Walking(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    input walking_direction,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging,
    output reg next_state
);
    always @(posedge areset or posedge clk) begin
        if (areset) begin
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b0;
            digging <= 1'b0;
            next_state <= WALKING;
        end else begin
            walk_left <= walking_direction;
            walk_right <= ~walking_direction;
            aaah <= 1'b0;
            digging <= 1'b0;
            if (~ground) begin
                next_state <= FALLING;
            end else if (dig) begin
                next_state <= DIGGING;
            end else if (bump_left || bump_right) begin
                next_state <= WALKING;
            end else begin
                next_state <= WALKING;
            end
        end
    end
endmodule

// Falling module
module Falling(
    input clk,
    input areset,
    input ground,
    input walking_direction,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging,
    output reg next_state,
    output reg fall_counter
);
    reg [4:0] local_fall_counter;
    always @(posedge areset or posedge clk) begin
        if (areset) begin
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b0;
            digging <= 1'b0;
            next_state <= FALLING;
            local_fall_counter <= 5'b0;
        end else begin
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b1;
            digging <= 1'b0;
            if (ground) begin
                next_state <= WALKING;
                local_fall_counter <= 5'b0;
            end else begin
                local_fall_counter <= local_fall_counter + 1'b1;
                if (local_fall_counter > 5'd20) begin
                    next_state <= SPLATTERED;
                end else begin
                    next_state <= FALLING;
                end
            end
        end
    end
    assign fall_counter = local_fall_counter;
endmodule

// Digging module
module Digging(
    input clk,
    input areset,
    input ground,
    input dig,
    input walking_direction,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging,
    output reg next_state
);
    always @(posedge areset or posedge clk) begin
        if (areset) begin
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b0;
            digging <= 1'b0;
            next_state <= DIGGING;
        end else begin
            walk_left <= walking_direction;
            walk_right <= ~walking_direction;
            aaah <= 1'b0;
            digging <= 1'b1;
            if (~ground) begin
                next_state <= FALLING;
            end else if (~dig) begin
                next_state <= WALKING;
            end else begin
                next_state <= DIGGING;
            end
        end
    end
endmodule

// Splattered module
module Splattered(
    input clk,
    input areset,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging,
    output reg next_state
);
    always @(posedge areset or posedge clk) begin
        if (areset) begin
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b0;
            digging <= 1'b0;
            next_state <= SPLATTERED;
        end else begin
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b0;
            digging <= 1'b0;
            next_state <= SPLATTERED;
        end
    end
endmodule

// Top-level module
Walking walking_module(
    .clk(clk),
    .areset(areset),
    .bump_left(bump_left),
    .bump_right(bump_right),
    .ground(ground),
    .dig(dig),
    .walking_direction(walking_direction),
    .walk_left(walk_left),
    .walk_right(walk_right),
    .aaah(aaah),
    .digging(digging),
    .next_state(state)
);

Falling falling_module(
    .clk(clk),
    .areset(areset),
    .ground(ground),
    .walking_direction(walking_direction),
    .walk_left(walk_left),
    .walk_right(walk_right),
    .aaah(aaah),
    .digging(digging),
    .next_state(state),
    .fall_counter(fall_counter)
);

Digging digging_module(
    .clk(clk),
    .areset(areset),
    .ground(ground),
    .dig(dig),
    .walking_direction(walking_direction),
    .walk_left(walk_left),
    .walk_right(walk_right),
    .aaah(aaah),
    .digging(digging),
    .next_state(state)
);

Splattered splattered_module(
    .clk(clk),
    .areset(areset),
    .walk_left(walk_left),
    .walk_right(walk_right),
    .aaah(aaah),
    .digging(digging),
    .next_state(state)
);

// State transition logic
always @(posedge clk) begin
    if (areset) begin
        state <= WALKING;
        walking_direction <= 1'b1; // walking left
    end else begin
        case (state)
            WALKING: begin
                if (~ground) begin
                    state <= FALLING;
                    walking_direction <= walking_direction; // preserve direction
                end else if (dig) begin
                    state <= DIGGING;
                end else if (bump_left || bump_right) begin
                    walking_direction <= ~walking_direction;
                end
            end
            FALLING: begin
                if (ground) begin
                    if (fall_counter > 5'd20) begin
                        state <= SPLATTERED;
                    end else begin
                        state <= WALKING;
                    end
                    fall_counter <= 5'b0; // reset counter
                end
            end
            DIGGING: begin
                if (~ground) begin
                    state <= FALLING;
                end else if (~dig) begin
                    state <= WALKING;
                end
            end
            SPLATTERED: begin
                // do nothing
            end
        endcase
    end
end

endmodule