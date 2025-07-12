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
    DIGGING = 2'b10,
    SPLATTERED = 2'b11
} top_state, next_top_state;

// Define the walking direction
reg walking_direction;

// Instantiate the walking module
WalkingModule walking_module(
    .clk(clk),
    .areset(areset),
    .bump_left(bump_left),
    .bump_right(bump_right),
    .walking_direction(walking_direction),
    .walk_left(walk_left),
    .walk_right(walk_right)
);

// Instantiate the falling module
FallingModule falling_module(
    .clk(clk),
    .areset(areset),
    .ground(ground),
    .falling(aaah),
    .splattered(top_state == SPLATTERED)
);

// Instantiate the digging module
DiggingModule digging_module(
    .clk(clk),
    .areset(areset),
    .dig(dig),
    .ground(ground),
    .digging(digging)
);

// Update the top-level state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        top_state <= WALKING;
    end else begin
        case (top_state)
            WALKING: begin
                if (!ground) begin
                    top_state <= FALLING;
                end else if (dig) begin
                    top_state <= DIGGING;
                end
            end
            FALLING: begin
                if (ground) begin
                    if (falling_module.fall_counter > 5'd20) begin
                        top_state <= SPLATTERED;
                    end else begin
                        top_state <= WALKING;
                    end
                end
            end
            DIGGING: begin
                if (!ground) begin
                    top_state <= FALLING;
                end else if (!dig) begin
                    top_state <= WALKING;
                end
            end
            SPLATTERED: begin
                top_state <= SPLATTERED;
            end
        endcase
    end
end

endmodule

module WalkingModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walking_direction,
    output reg walk_left,
    output reg walk_right
);

// Update the walking direction
always @(posedge clk or posedge areset) begin
    if (areset) begin
        walking_direction <= 1'b0;
    end else begin
        if (bump_left || (bump_left && bump_right)) begin
            walking_direction <= 1'b0;
        end else if (bump_right) begin
            walking_direction <= 1'b1;
        end
    end
end

// Assign the walking outputs
assign walk_left = ~walking_direction;
assign walk_right = walking_direction;

endmodule

module FallingModule(
    input clk,
    input areset,
    input ground,
    output reg falling,
    output reg splattered
);

// Define the fall counter
reg [4:0] fall_counter;

// Update the fall counter
always @(posedge clk or posedge areset) begin
    if (areset) begin
        fall_counter <= 5'b0;
    end else begin
        if (!ground) begin
            fall_counter <= fall_counter + 1'b1;
        end else begin
            fall_counter <= 5'b0;
        end
    end
end

// Assign the falling output
assign falling = !ground;
assign splattered = fall_counter > 5'd20;

endmodule

module DiggingModule(
    input clk,
    input areset,
    input dig,
    input ground,
    output reg digging
);

// Update the digging output
always @(posedge clk or posedge areset) begin
    if (areset) begin
        digging <= 1'b0;
    end else begin
        if (dig && ground) begin
            digging <= 1'b1;
        end else if (!dig || !ground) begin
            digging <= 1'b0;
        end
    end
end

endmodule