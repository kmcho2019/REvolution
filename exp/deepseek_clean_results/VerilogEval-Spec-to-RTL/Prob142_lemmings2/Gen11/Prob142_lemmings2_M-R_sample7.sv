module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

    parameter LEFT = 2'b00;
    parameter RIGHT = 2'b01;
    parameter FALLING = 2'b10;
    
    reg [1:0] state, next_state;
    reg pre_fall_dir;  // 0=left, 1=right
    
    // State transition logic
    always @(*) begin
        case (state)
            LEFT: begin
                if (!ground) begin
                    next_state = FALLING;
                    pre_fall_dir = 0;
                end
                else if (bump_left) begin
                    next_state = RIGHT;
                end
                else begin
                    next_state = LEFT;
                end
            end
            RIGHT: begin
                if (!ground) begin
                    next_state = FALLING;
                    pre_fall_dir = 1;
                end
                else if (bump_right) begin
                    next_state = LEFT;
                end
                else begin
                    next_state = RIGHT;
                end
            end
            FALLING: begin
                if (ground) begin
                    next_state = pre_fall_dir ? RIGHT : LEFT;
                end
                else begin
                    next_state = FALLING;
                end
            end
            default: next_state = LEFT;
        endcase
    end
    
    // State register
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= LEFT;
        end
        else begin
            state <= next_state;
        end
    end
    
    // Output logic
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah = (state == FALLING);

endmodule