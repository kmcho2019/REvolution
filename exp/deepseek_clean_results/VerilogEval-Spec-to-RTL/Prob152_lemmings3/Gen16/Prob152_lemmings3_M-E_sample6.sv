module TopModule (
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

    // One-hot encoded states
    parameter WALK_L = 3'b001;
    parameter WALK_R = 3'b010;
    parameter FALL   = 3'b100;
    parameter DIG_L  = 3'b101;
    parameter DIG_R  = 3'b110;

    reg [2:0] state;
    reg prev_ground;

    // Edge detection for ground signal
    wire ground_falling_edge = prev_ground & ~ground;
    wire ground_rising_edge = ~prev_ground & ground;

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_L;
            prev_ground <= 1;
        end else begin
            prev_ground <= ground;
            
            case (state)
                WALK_L, WALK_R: begin
                    if (ground_falling_edge)
                        state <= FALL;
                    else if (ground && dig)
                        state <= (state == WALK_L) ? DIG_L : DIG_R;
                    else if (ground) begin
                        if (bump_left && state == WALK_L)
                            state <= WALK_R;
                        else if (bump_right && state == WALK_R)
                            state <= WALK_L;
                    end
                end
                
                FALL: begin
                    if (ground_rising_edge)
                        state <= (prev_ground) ? WALK_L : 
                               ((state == DIG_L) ? WALK_L : WALK_R);
                end
                
                DIG_L, DIG_R: begin
                    if (ground_falling_edge)
                        state <= FALL;
                end
            endcase
        end
    end

    // Output logic
    assign walk_left  = (state == WALK_L) || (state == DIG_L);
    assign walk_right = (state == WALK_R) || (state == DIG_R);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG_L) || (state == DIG_R);

endmodule