module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

reg [1:0] state; // Current state of the machine
reg [5:0] fall_count; // Counter for the number of clock cycles the Lemming has been falling
reg direction; // Current direction of the Lemming (1 for right, 0 for left)

localparam WALK_LEFT = 2'b00;
localparam WALK_RIGHT = 2'b01;
localparam FALLING = 2'b10;
localparam DIGGING = 2'b11;

// Initialize the state machine
initial state = WALK_LEFT;
initial direction = 0;
initial fall_count = 0;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        direction <= 0;
        fall_count <= 0;
    end
    else begin
        case (state)
            WALK_LEFT: begin
                if (!ground) begin
                    state <= FALLING;
                    fall_count <= 1;
                end
                else if (dig) begin
                    state <= DIGGING;
                end
                else if (bump_left) begin
                    direction <= 1;
                    state <= WALK_RIGHT;
                end
                else if (bump_right) begin
                    // No change in state or direction
                end
            end
            WALK_RIGHT: begin
                if (!ground) begin
                    state <= FALLING;
                    fall_count <= 1;
                end
                else if (dig) begin
                    state <= DIGGING;
                end
                else if (bump_right) begin
                    direction <= 0;
                    state <= WALK_LEFT;
                end
                else if (bump_left) begin
                    // No change in state or direction
                end
            end
            FALLING: begin
                fall_count <= fall_count + 1;
                if (ground) begin
                    if (fall_count > 20) begin
                        state <= 2'b00; // This state does not correspond to any of the normal states, so the outputs will be 0
                    end
                    else begin
                        if (direction) begin
                            state <= WALK_RIGHT;
                        end
                        else begin
                            state <= WALK_LEFT;
                        end
                        fall_count <= 0;
                    end
                end
            end
            DIGGING: begin
                if (!ground) begin
                    state <= FALLING;
                    fall_count <= 1;
                end
                else begin
                    // Continue digging
                end
            end
            default: begin
                // This state does not correspond to any of the normal states, so the outputs will be 0
            end
        endcase
    end
end

// Output logic
always @(*) begin
    walk_left = (state == WALK_LEFT || state == DIGGING) && direction == 0;
    walk_right = (state == WALK_RIGHT || state == DIGGING) && direction == 1;
    aaah = state == FALLING;
    digging = state == DIGGING;
end

endmodule