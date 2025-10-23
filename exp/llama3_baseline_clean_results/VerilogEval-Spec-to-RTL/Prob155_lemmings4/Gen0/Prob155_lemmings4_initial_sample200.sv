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

// Define the states
localparam S_WALK_LEFT = 0;
localparam S_WALK_RIGHT = 1;
localparam S_FALLING = 2;
localparam S_DIGGING = 3;
localparam S_SPLATTERED = 4;

reg [1:0] state;
reg [4:0] fall_counter;

// Initialize the state to S_WALK_LEFT
initial begin
    state = S_WALK_LEFT;
end

// Reset the state to S_WALK_LEFT on areset
always @(posedge areset) begin
    state = S_WALK_LEFT;
    fall_counter = 0;
end

// State transitions
always @(posedge clk) begin
    case (state)
        S_WALK_LEFT: begin
            if (!ground) begin
                state = S_FALLING;
            end else if (dig) begin
                state = S_DIGGING;
            end else if (bump_right) begin
                state = S_WALK_RIGHT;
            end else if (bump_left) begin
                state = S_WALK_LEFT;
            end
        end
        S_WALK_RIGHT: begin
            if (!ground) begin
                state = S_FALLING;
            end else if (dig) begin
                state = S_DIGGING;
            end else if (bump_left) begin
                state = S_WALK_LEFT;
            end else if (bump_right) begin
                state = S_WALK_RIGHT;
            end
        end
        S_FALLING: begin
            if (ground) begin
                if (fall_counter > 20) begin
                    state = S_SPLATTERED;
                end else begin
                    if (state == S_WALK_LEFT) begin
                        state = S_WALK_LEFT;
                    end else begin
                        state = S_WALK_RIGHT;
                    end
                end
            end
            fall_counter = fall_counter + 1;
        end
        S_DIGGING: begin
            if (!ground) begin
                state = S_FALLING;
            end
        end
        S_SPLATTERED: begin
            // Stay in this state forever
        end
    endcase
end

// Output logic
always @(*) begin
    case (state)
        S_WALK_LEFT: begin
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
        S_WALK_RIGHT: begin
            walk_left = 0;
            walk_right = 1;
            aaah = 0;
            digging = 0;
        end
        S_FALLING: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 1;
            digging = 0;
        end
        S_DIGGING: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 1;
        end
        S_SPLATTERED: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
    endcase
end

endmodule