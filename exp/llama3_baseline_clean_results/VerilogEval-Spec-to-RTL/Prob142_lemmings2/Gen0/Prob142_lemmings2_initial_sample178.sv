module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

// Define states
parameter IDLE_LEFT = 2'b00;
parameter IDLE_RIGHT = 2'b01;
parameter FALLING = 2'b10;

reg [1:0] state, next_state;
reg [1:0] prev_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
        prev_state <= IDLE_LEFT;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        IDLE_LEFT: begin
            if (bump_left) begin
                next_state <= IDLE_RIGHT;
            end else if (!ground) begin
                next_state <= FALLING;
                prev_state <= IDLE_LEFT;
            end else begin
                next_state <= IDLE_LEFT;
            end
        end
        IDLE_RIGHT: begin
            if (bump_right) begin
                next_state <= IDLE_LEFT;
            end else if (!ground) begin
                next_state <= FALLING;
                prev_state <= IDLE_RIGHT;
            end else begin
                next_state <= IDLE_RIGHT;
            end
        end
        FALLING: begin
            if (ground) begin
                if (prev_state == IDLE_LEFT) begin
                    next_state <= IDLE_LEFT;
                end else if (prev_state == IDLE_RIGHT) begin
                    next_state <= IDLE_RIGHT;
                end
            end else begin
                next_state <= FALLING;
            end
        end
    endcase
end

always @(*) begin
    case (state)
        IDLE_LEFT: begin
            walk_left <= 1'b1;
            walk_right <= 1'b0;
            aaah <= 1'b0;
        end
        IDLE_RIGHT: begin
            walk_left <= 1'b0;
            walk_right <= 1'b1;
            aaah <= 1'b0;
        end
        FALLING: begin
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b1;
        end
    endcase
end

endmodule