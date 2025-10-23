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

    // State encoding parameters
    parameter [1:0] WALK_LEFT  = 2'b00;
    parameter [1:0] WALK_RIGHT = 2'b01;
    parameter [1:0] FALL       = 2'b10;
    parameter [1:0] DIG        = 2'b11;

    reg [1:0] state;
    reg walking_left;  // Track direction separately

    // Next state logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            walking_left <= 1;
        end else begin
            case (state)
                WALK_LEFT, WALK_RIGHT: begin
                    if (~ground) begin
                        state <= FALL;
                    end else if (dig) begin
                        state <= DIG;
                    end else if (bump_left || bump_right) begin
                        // Handle direction change
                        if (bump_left && bump_right) begin
                            walking_left <= ~walking_left;
                        end else if (bump_left) begin
                            walking_left <= 0;
                        end else if (bump_right) begin
                            walking_left <= 1;
                        end
                        // Stay in walking state
                        state <= walking_left ? WALK_LEFT : WALK_RIGHT;
                    end
                end
                
                FALL: begin
                    if (ground) begin
                        state <= walking_left ? WALK_LEFT : WALK_RIGHT;
                    end
                end
                
                DIG: begin
                    if (~ground) begin
                        state <= FALL;
                    end
                end
            endcase
        end
    end

    // Output logic
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule