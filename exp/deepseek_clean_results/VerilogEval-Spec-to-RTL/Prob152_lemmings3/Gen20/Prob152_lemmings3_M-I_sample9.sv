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

    // States with dedicated DIG state
    parameter WALK = 2'b00;
    parameter FALL = 2'b01;
    parameter DIG  = 2'b10;

    reg [1:0] state;
    reg direction; // 0=left, 1=right
    reg bump_left_prev, bump_right_prev;

    // Edge detection for bumps
    wire bump_left_edge = bump_left & ~bump_left_prev;
    wire bump_right_edge = bump_right & ~bump_right_prev;

    // Pre-compute falling condition
    wire falling = !ground;

    // State transitions with optimized priority logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 0;
            bump_left_prev <= 0;
            bump_right_prev <= 0;
        end
        else begin
            bump_left_prev <= bump_left;
            bump_right_prev <= bump_right;
            
            case (state)
                WALK: begin
                    if (falling) begin
                        state <= FALL;
                    end
                    else if (dig & ground) begin
                        state <= DIG;
                    end
                    else if (bump_left_edge) begin
                        direction <= 1;
                    end
                    else if (bump_right_edge) begin
                        direction <= 0;
                    end
                end
                
                DIG: begin
                    if (falling) begin
                        state <= FALL;
                    end
                end
                
                FALL: begin
                    if (ground) begin
                        state <= WALK;
                    end
                end
            endcase
        end
    end

    // Optimized output logic with shared terms
    wire walking = (state == WALK);
    assign walk_left  = walking & ~direction;
    assign walk_right = walking & direction;
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule