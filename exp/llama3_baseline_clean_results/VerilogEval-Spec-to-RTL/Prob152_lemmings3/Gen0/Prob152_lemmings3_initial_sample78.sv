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

reg [2:0] state;
reg [2:0] next_state;

// Define states
localparam IDLE_LEFT = 3'b001;
localparam IDLE_RIGHT = 3'b010;
localparam FALLING = 3'b011;
localparam DIGGING_LEFT = 3'b100;
localparam DIGGING_RIGHT = 3'b101;

// Assign outputs based on state
always @(*)
begin
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;

    case (state)
        IDLE_LEFT: walk_left = 1'b1;
        IDLE_RIGHT: walk_right = 1'b1;
        FALLING: aaah = 1'b1;
        DIGGING_LEFT: 
        begin
            walk_left = 1'b1;
            digging = 1'b1;
        end
        DIGGING_RIGHT: 
        begin
            walk_right = 1'b1;
            digging = 1'b1;
        end
        default: ;
    endcase
end

// Next state logic
always @(*)
begin
    next_state = state;

    case (state)
        IDLE_LEFT:
        begin
            if (!ground) next_state = FALLING;
            else if (dig) next_state = DIGGING_LEFT;
            else if (bump_left) next_state = IDLE_RIGHT;
            else if (bump_right) next_state = IDLE_LEFT;
        end

        IDLE_RIGHT:
        begin
            if (!ground) next_state = FALLING;
            else if (dig) next_state = DIGGING_RIGHT;
            else if (bump_left) next_state = IDLE_LEFT;
            else if (bump_right) next_state = IDLE_RIGHT;
        end

        FALLING:
        begin
            if (ground) 
            begin
                if (state == IDLE_LEFT || state == DIGGING_LEFT) next_state = IDLE_LEFT;
                else next_state = IDLE_RIGHT;
            end
        end

        DIGGING_LEFT:
        begin
            if (!ground) next_state = FALLING;
        end

        DIGGING_RIGHT:
        begin
            if (!ground) next_state = FALLING;
        end

        default: next_state = IDLE_LEFT;
    endcase
end

// State register
always @(posedge clk or posedge areset)
begin
    if (areset) state <= IDLE_LEFT;
    else state <= next_state;
end

endmodule