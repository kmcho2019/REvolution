module TopModule (
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
parameter IDLE_LEFT = 4'b0001;
parameter IDLE_RIGHT = 4'b0010;
parameter FALLING = 4'b0100;
parameter DIGGING_LEFT = 4'b1000;
parameter DIGGING_RIGHT = 4'b1001;

reg [3:0] state;
reg [3:0] next_state;

// State register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        IDLE_LEFT: begin
            if (!ground) begin
                next_state <= FALLING;
            end else if (dig) begin
                next_state <= DIGGING_LEFT;
            end else if (bump_left) begin
                next_state <= IDLE_RIGHT;
            end else if (bump_right) begin
                next_state <= IDLE_LEFT;
            end else begin
                next_state <= IDLE_LEFT;
            end
        end
        IDLE_RIGHT: begin
            if (!ground) begin
                next_state <= FALLING;
            end else if (dig) begin
                next_state <= DIGGING_RIGHT;
            end else if (bump_left) begin
                next_state <= IDLE_RIGHT;
            end else if (bump_right) begin
                next_state <= IDLE_LEFT;
            end else begin
                next_state <= IDLE_RIGHT;
            end
        end
        FALLING: begin
            if (ground) begin
                if (state == DIGGING_LEFT) begin
                    next_state <= IDLE_LEFT;
                end else if (state == DIGGING_RIGHT) begin
                    next_state <= IDLE_RIGHT;
                end else if (state == FALLING) begin
                    if (bump_left) begin
                        next_state <= IDLE_RIGHT;
                    end else if (bump_right) begin
                        next_state <= IDLE_LEFT;
                    end else begin
                        next_state <= IDLE_LEFT; // Assume left by default
                    end
                end else begin
                    next_state <= IDLE_LEFT; // Assume left by default
                end
            end else begin
                next_state <= FALLING;
            end
        end
        DIGGING_LEFT: begin
            if (!ground) begin
                next_state <= FALLING;
            end else begin
                next_state <= DIGGING_LEFT;
            end
        end
        DIGGING_RIGHT: begin
            if (!ground) begin
                next_state <= FALLING;
            end else begin
                next_state <= DIGGING_RIGHT;
            end
        end
        default: next_state <= IDLE_LEFT;
    endcase
end

// Output logic
always @(*) begin
    case (state)
        IDLE_LEFT: begin
            walk_left <= 1'b1;
            walk_right <= 1'b0;
            aaah <= 1'b0;
            digging <= 1'b0;
        end
        IDLE_RIGHT: begin
            walk_left <= 1'b0;
            walk_right <= 1'b1;
            aaah <= 1'b0;
            digging <= 1'b0;
        end
        FALLING: begin
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b1;
            digging <= 1'b0;
        end
        DIGGING_LEFT: begin
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b0;
            digging <= 1'b1;
        end
        DIGGING_RIGHT: begin
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b0;
            digging <= 1'b1;
        end
        default: begin
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b0;
            digging <= 1'b0;
        end
    endcase
end

endmodule