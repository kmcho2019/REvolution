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

    // One-hot encoded states
    parameter LEFT      = 2'b00;
    parameter RIGHT     = 2'b01;
    parameter FALL_LEFT = 2'b10;
    parameter FALL_RIGHT= 2'b11;
    
    reg [1:0] state, next_state;
    reg bump_left_sync, bump_right_sync;
    
    // Synchronize bump inputs
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            bump_left_sync <= 0;
            bump_right_sync <= 0;
        end else begin
            bump_left_sync <= bump_left;
            bump_right_sync <= bump_right;
        end
    end
    
    // State transition logic
    always @(*) begin
        case (state)
            LEFT: begin
                if (!ground) next_state = FALL_LEFT;
                else if (bump_left_sync) next_state = RIGHT;
                else next_state = LEFT;
            end
            RIGHT: begin
                if (!ground) next_state = FALL_RIGHT;
                else if (bump_right_sync) next_state = LEFT;
                else next_state = RIGHT;
            end
            FALL_LEFT: begin
                if (ground) next_state = LEFT;
                else next_state = FALL_LEFT;
            end
            FALL_RIGHT: begin
                if (ground) next_state = RIGHT;
                else next_state = FALL_RIGHT;
            end
            default: next_state = LEFT;
        endcase
    end
    
    // State register
    always @(posedge clk or posedge areset) begin
        if (areset) state <= LEFT;
        else state <= next_state;
    end
    
    // Output logic
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah = (state == FALL_LEFT) || (state == FALL_RIGHT);

endmodule