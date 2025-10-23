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

// State enumeration
localparam IDLE_LEFT = 0;
localparam IDLE_RIGHT = 1;
localparam FALLING = 2;
localparam DIGGING_LEFT = 3;
localparam DIGGING_RIGHT = 4;

reg [2:0] current_state;
reg [2:0] next_state;

// State register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= IDLE_LEFT;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        IDLE_LEFT: begin
            if (!ground) begin
                next_state <= FALLING;
            end else if (dig) begin
                next_state <= DIGGING_LEFT;
            end else if (bump_left) begin
                next_state <= IDLE_RIGHT;
            end else if (bump_right) begin
                next_state <= IDLE_LEFT; // Already walking left
            end else begin
                next_state <= IDLE_LEFT; // No change
            end
        end
        IDLE_RIGHT: begin
            if (!ground) begin
                next_state <= FALLING;
            end else if (dig) begin
                next_state <= DIGGING_RIGHT;
            end else if (bump_right) begin
                next_state <= IDLE_LEFT;
            end else if (bump_left) begin
                next_state <= IDLE_RIGHT; // Already walking right
            end else begin
                next_state <= IDLE_RIGHT; // No change
            end
        end
        FALLING: begin
            if (ground) begin
                if (current_state == FALLING && (current_state == IDLE_LEFT || current_state == DIGGING_LEFT)) begin
                    next_state <= IDLE_LEFT;
                end else if (current_state == FALLING && (current_state == IDLE_RIGHT || current_state == DIGGING_RIGHT)) begin
                    next_state <= IDLE_RIGHT;
                end
            end else begin
                next_state <= FALLING; // Continue falling
            end
        end
        DIGGING_LEFT: begin
            if (!ground) begin
                next_state <= FALLING;
            end else if (!dig) begin
                next_state <= IDLE_LEFT; // Stop digging
            end else begin
                next_state <= DIGGING_LEFT; // Continue digging
            end
        end
        DIGGING_RIGHT: begin
            if (!ground) begin
                next_state <= FALLING;
            end else if (!dig) begin
                next_state <= IDLE_RIGHT; // Stop digging
            end else begin
                next_state <= DIGGING_RIGHT; // Continue digging
            end
        end
        default: next_state <= IDLE_LEFT;
    endcase
end

// Output logic
always @(*) begin
    case (current_state)
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
            walk_left <= 1'b1;
            walk_right <= 1'b0;
            aaah <= 1'b0;
            digging <= 1'b1;
        end
        DIGGING_RIGHT: begin
            walk_left <= 1'b0;
            walk_right <= 1'b1;
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