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

// Encoding of states
localparam IDLE_LEFT = 3'b000;
localparam IDLE_RIGHT = 3'b001;
localparam FALLING = 3'b010;
localparam DIGGING_LEFT = 3'b100;
localparam DIGGING_RIGHT = 3'b101;

// Output signals based on the current state
always @(*) begin
    case (state)
        IDLE_LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
        IDLE_RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b0;
        end
        FALLING: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
        end
        DIGGING_LEFT: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
        end
        DIGGING_RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
        end
        default: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
    endcase
end

// Next state logic
always @(*) begin
    next_state = state;
    case (state)
        IDLE_LEFT: begin
            if (!ground) begin
                next_state = FALLING;
            end
            else if (dig) begin
                next_state = DIGGING_LEFT;
            end
            else if (bump_left) begin
                next_state = IDLE_RIGHT;
            end
            else if (bump_right) begin
                // Do nothing
            end
        end
        IDLE_RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
            end
            else if (dig) begin
                next_state = DIGGING_RIGHT;
            end
            else if (bump_left) begin
                // Do nothing
            end
            else if (bump_right) begin
                next_state = IDLE_LEFT;
            end
        end
        FALLING: begin
            if (ground) begin
                if (state == IDLE_LEFT) begin
                    next_state = IDLE_LEFT;
                end
                else if (state == IDLE_RIGHT) begin
                    next_state = IDLE_RIGHT;
                end
                else if (state == DIGGING_LEFT) begin
                    next_state = IDLE_LEFT;
                end
                else if (state == DIGGING_RIGHT) begin
                    next_state = IDLE_RIGHT;
                end
            end
        end
        DIGGING_LEFT: begin
            if (!ground) begin
                next_state = FALLING;
            end
        end
        DIGGING_RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
            end
        end
        default: begin
            next_state = IDLE_LEFT;
        end
    endcase
end

// State register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
    end
    else begin
        state <= next_state;
    end
end

endmodule