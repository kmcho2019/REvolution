module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

    // Gray-coded states
    parameter [1:0] LEFT  = 2'b00;
    parameter [1:0] RIGHT = 2'b01;
    parameter [1:0] FALL  = 2'b11;
    
    reg [1:0] state, next_state;
    reg ground_prev;
    wire ground_falling = ~ground & ground_prev;
    wire ground_rising = ground & ~ground_prev;
    
    // Clock gating control
    wire clk_en = (state != FALL);
    reg gated_clk;
    
    // State transition logic
    always @(*) begin
        case (state)
            LEFT: begin
                if (ground_falling) next_state = FALL;
                else if (bump_left) next_state = RIGHT;
                else next_state = LEFT;
            end
            RIGHT: begin
                if (ground_falling) next_state = FALL;
                else if (bump_right) next_state = LEFT;
                else next_state = RIGHT;
            end
            FALL: begin
                if (ground_rising) next_state = (ground_prev) ? LEFT : RIGHT;
                else next_state = FALL;
            end
            default: next_state = LEFT;
        endcase
    end
    
    // Clock gating logic
    always @(posedge clk or posedge areset) begin
        if (areset) gated_clk <= 1'b0;
        else gated_clk <= clk & clk_en;
    end
    
    // State and ground history registers
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= LEFT;
            ground_prev <= 1'b1;
        end
        else begin
            state <= next_state;
            ground_prev <= ground;
        end
    end
    
    // Registered outputs for better timing
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            walk_left <= 1'b1;
            walk_right <= 1'b0;
            aaah <= 1'b0;
        end
        else begin
            walk_left <= (state == LEFT);
            walk_right <= (state == RIGHT);
            aaah <= (state == FALL);
        end
    end

endmodule