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

// Define the states
localparam IDLE_LEFT = 3'b000;
localparam IDLE_RIGHT = 3'b001;
localparam FALLING = 3'b010;
localparam DIGGING_LEFT = 3'b100;
localparam DIGGING_RIGHT = 3'b101;

reg [2:0] state, next_state;

// Sequential logic
always @ (posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
    end else begin
        state <= next_state;
    end
end

// Combinational logic
always @ (*) begin
    next_state = state;
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;

    case (state)
        IDLE_LEFT: begin
            walk_left = 1;
            if (~ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING_LEFT;
                digging = 1;
            end else if (bump_left || bump_right) begin
                next_state = IDLE_RIGHT;
            end
        end
        IDLE_RIGHT: begin
            walk_right = 1;
            if (~ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING_RIGHT;
                digging = 1;
            end else if (bump_left || bump_right) begin
                next_state = IDLE_LEFT;
            end
        end
        FALLING: begin
            aaah = 1;
            if (ground) begin
                if (state == FALLING) begin
                    next_state = (dig ? (walk_left ? DIGGING_LEFT : DIGGING_RIGHT) : (walk_left ? IDLE_LEFT : IDLE_RIGHT));
                    digging = (dig ? 1 : 0);
                end else begin
                    next_state = (walk_left ? IDLE_LEFT : IDLE_RIGHT);
                end
            end
        end
        DIGGING_LEFT: begin
            walk_left = 1;
            digging = 1;
            if (~ground) begin
                next_state = FALLING;
            end
        end
        DIGGING_RIGHT: begin
            walk_right = 1;
            digging = 1;
            if (~ground) begin
                next_state = FALLING;
            end
        end
    endcase
end

reg walk_left_prev;
reg walk_right_prev;

always @ (posedge clk) begin
    walk_left_prev <= walk_left;
    walk_right_prev <= walk_right;
end

assign walk_left = walk_left ? 1 : walk_left_prev;
assign walk_right = walk_right ? 1 : walk_right_prev;

endmodule