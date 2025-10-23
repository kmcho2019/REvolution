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

reg [2:0] state, next_state;
reg [5:0] fall_count, next_fall_count;

// State encoding
localparam IDLE_LEFT = 3'b001;
localparam IDLE_RIGHT = 3'b010;
localparam FALLING = 3'b011;
localparam DIGGING = 3'b100;
localparam SPLATTERED = 3'b000;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
        fall_count <= 6'd0;
    end else begin
        state <= next_state;
        fall_count <= next_fall_count;
    end
end

always @(*) begin
    next_state = state;
    next_fall_count = fall_count;
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;

    case (state)
        IDLE_LEFT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = IDLE_RIGHT;
            end else if (bump_right) begin
                next_state = IDLE_LEFT;
            end
            walk_left = 1'b1;
        end

        IDLE_RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = IDLE_LEFT;
            end else if (bump_right) begin
                next_state = IDLE_RIGHT;
            end
            walk_right = 1'b1;
        end

        FALLING: begin
            next_fall_count = fall_count + 1;
            if (ground) begin
                if (fall_count > 20) begin
                    next_state = SPLATTERED;
                end else if (state == IDLE_LEFT) begin
                    next_state = IDLE_LEFT;
                end else if (state == IDLE_RIGHT) begin
                    next_state = IDLE_RIGHT;
                end
            end
            aaah = 1'b1;
        end

        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
            end
            digging = 1'b1;
            walk_left = 1'b1;
        end

        SPLATTERED: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
    endcase
end

endmodule