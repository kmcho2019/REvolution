module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

// State machine states
parameter IDLE_LEFT = 4'b0001;
parameter IDLE_RIGHT = 4'b0010;
parameter FALLING = 4'b0100;
parameter DIGGING = 4'b1000;
parameter SPLATTERED = 4'b0000;

// Current state register
reg [3:0] state;
reg [3:0] next_state;

// Falling counter
reg [5:0] fall_count;
reg [5:0] next_fall_count;

// Determine next state and outputs
always @(*) begin
    // Defaults
    next_state = state;
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;
    next_fall_count = fall_count;

    case (state)
        IDLE_LEFT: begin
            if (!ground) begin
                next_state = FALLING;
                aaah = 1;
                next_fall_count = 1;
            end else if (dig) begin
                next_state = DIGGING;
                digging = 1;
            end else if (bump_left) begin
                next_state = IDLE_RIGHT;
            end else if (bump_right) begin
                // No change
            end else begin
                walk_left = 1;
            end
        end
        IDLE_RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
                aaah = 1;
                next_fall_count = 1;
            end else if (dig) begin
                next_state = DIGGING;
                digging = 1;
            end else if (bump_right) begin
                next_state = IDLE_LEFT;
            end else if (bump_left) begin
                // No change
            end else begin
                walk_right = 1;
            end
        end
        FALLING: begin
            if (ground) begin
                if (fall_count > 20) begin
                    next_state = SPLATTERED;
                end else if (state == IDLE_LEFT) begin
                    next_state = IDLE_LEFT;
                    walk_left = 1;
                end else begin
                    next_state = IDLE_RIGHT;
                    walk_right = 1;
                end
            end else begin
                aaah = 1;
                next_fall_count = fall_count + 1;
            end
        end
        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
                aaah = 1;
                next_fall_count = 1;
            end else begin
                digging = 1;
                if (state == IDLE_LEFT) begin
                    walk_left = 1;
                end else begin
                    walk_right = 1;
                end
            end
        end
        SPLATTERED: begin
            // No change
        end
        default: begin
            // No change
        end
    endcase
end

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
        fall_count <= 0;
    end else begin
        state <= next_state;
        fall_count <= next_fall_count;
    end
end

endmodule