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

reg [1:0] state;
reg [1:0] next_state;
reg walk_left_reg;
reg walk_right_reg;
reg aaah_reg;
reg digging_reg;
reg direction; // 1 for right, 0 for left

localparam IDLE_LEFT = 2'b00;
localparam IDLE_RIGHT = 2'b01;
localparam FALLING = 2'b10;
localparam DIGGING = 2'b11;

always @(*) begin
    next_state = state;
    walk_left_reg = 0;
    walk_right_reg = 0;
    aaah_reg = 0;
    digging_reg = 0;
    
    case(state)
        IDLE_LEFT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig && ground) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = IDLE_RIGHT;
            end else if (bump_right) begin
                next_state = IDLE_LEFT;
            end else begin
                walk_left_reg = 1;
            end
        end
        IDLE_RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig && ground) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = IDLE_LEFT;
            end else if (bump_right) begin
                next_state = IDLE_RIGHT;
            end else begin
                walk_right_reg = 1;
            end
        end
        FALLING: begin
            if (ground) begin
                if (direction) begin
                    next_state = IDLE_RIGHT;
                end else begin
                    next_state = IDLE_LEFT;
                end
            end else begin
                aaah_reg = 1;
            end
        end
        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
            end else begin
                digging_reg = 1;
            end
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
        direction <= 0;
    end else begin
        state <= next_state;
        if (next_state == IDLE_RIGHT) begin
            direction <= 1;
        end else if (next_state == IDLE_LEFT) begin
            direction <= 0;
        end
    end
end

assign walk_left = walk_left_reg;
assign walk_right = walk_right_reg;
assign aaah = aaah_reg;
assign digging = digging_reg;

endmodule