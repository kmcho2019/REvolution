module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

reg [1:0] state;
reg [1:0] next_state;

localparam IDLE_LEFT = 2'b00;
localparam IDLE_RIGHT = 2'b01;
localparam FALLING = 2'b10;
localparam DIGGING = 2'b11;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        IDLE_LEFT: begin
            if (!ground) begin
                next_state <= FALLING;
            end else if (dig) begin
                next_state <= DIGGING;
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
                next_state <= DIGGING;
            end else if (bump_left) begin
                next_state <= IDLE_LEFT;
            end else if (bump_right) begin
                next_state <= IDLE_RIGHT;
            end else begin
                next_state <= IDLE_RIGHT;
            end
        end
        FALLING: begin
            if (ground) begin
                next_state <= (bump_left)? IDLE_RIGHT : (bump_right)? IDLE_LEFT : (state == IDLE_LEFT)? IDLE_LEFT : IDLE_RIGHT;
            end else begin
                next_state <= FALLING;
            end
        end
        DIGGING: begin
            if (!ground) begin
                next_state <= FALLING;
            end else begin
                next_state <= DIGGING;
            end
        end
        default: next_state <= IDLE_LEFT;
    endcase
end

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
        DIGGING: begin
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