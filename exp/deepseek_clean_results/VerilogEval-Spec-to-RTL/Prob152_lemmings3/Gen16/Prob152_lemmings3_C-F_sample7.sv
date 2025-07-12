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

    // State parameters with embedded direction
    parameter WALK_LEFT  = 2'b00;
    parameter WALK_RIGHT = 2'b01;
    parameter FALL_LEFT  = 2'b10;
    parameter FALL_RIGHT = 2'b11;

    reg [1:0] state;
    reg is_digging;

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            is_digging <= 1'b0;
        end else begin
            case (state)
                WALK_LEFT, WALK_RIGHT: begin
                    if (~ground) begin
                        state <= state[0] ? FALL_RIGHT : FALL_LEFT;
                        is_digging <= 1'b0;
                    end else if (dig) begin
                        is_digging <= 1'b1;
                    end else if (~is_digging) begin
                        // Handle bumps - priority to right if both
                        if (bump_left) state <= WALK_RIGHT;
                        else if (bump_right) state <= WALK_LEFT;
                    end
                end
                
                FALL_LEFT, FALL_RIGHT: begin
                    if (ground) begin
                        state <= state[0] ? WALK_RIGHT : WALK_LEFT;
                        is_digging <= 1'b0;
                    end
                end
            endcase
        end
    end

    // Output logic - simplified using state parameters
    assign walk_left  = (state == WALK_LEFT) & ~is_digging;
    assign walk_right = (state == WALK_RIGHT) & ~is_digging;
    assign aaah = state[1]; // All fall states have bit[1] set
    assign digging = ~state[1] & is_digging; // Walking and digging

endmodule