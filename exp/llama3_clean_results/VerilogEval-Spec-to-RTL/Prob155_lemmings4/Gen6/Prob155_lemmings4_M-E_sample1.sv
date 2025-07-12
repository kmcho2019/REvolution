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

// Define the states and sub-states
parameter WALKING = 2'b00;
parameter FALLING = 2'b01;
parameter DIGGING = 2'b10;
parameter SPLATTERED = 2'b11;

parameter WALK_LEFT = 1'b0;
parameter WALK_RIGHT = 1'b1;

// Define the fall counter module
module fall_counter(
    input clk,
    input reset,
    input enable,
    output reg [4:0] count
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        count <= 5'b0;
    end else if (enable) begin
        count <= count + 1'b1;
    end
end

endmodule

// Define the state machine
reg [1:0] state;
reg [0:0] walking_direction;
reg [4:0] fall_count;

fall_counter fall_counter_inst(
    .clk(clk),
    .reset(areset),
    .enable(state == FALLING),
    .count(fall_count)
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING;
        walking_direction <= WALK_LEFT;
    end else begin
        case (state)
            WALKING: begin
                if (!ground) begin
                    state <= FALLING;
                end else if (dig) begin
                    state <= DIGGING;
                end else if (bump_left || bump_right) begin
                    walking_direction <= ~walking_direction;
                end
            end
            FALLING: begin
                if (ground) begin
                    if (fall_count > 5'd20) begin
                        state <= SPLATTERED;
                    end else begin
                        state <= WALKING;
                    end
                end
            end
            DIGGING: begin
                if (!ground) begin
                    state <= FALLING;
                end
            end
            SPLATTERED: begin
                // stay in this state forever
            end
        endcase
    end
end

always @* begin
    walk_left = (state == WALKING && walking_direction == WALK_LEFT && state != SPLATTERED);
    walk_right = (state == WALKING && walking_direction == WALK_RIGHT && state != SPLATTERED);
    aaah = (state == FALLING && state != SPLATTERED);
    digging = (state == DIGGING && state != SPLATTERED);
end

endmodule