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

    // Combined direction and activity states
    parameter WALK_LEFT = 3'b000;
    parameter WALK_RIGHT = 3'b001;
    parameter DIG_LEFT = 3'b010;
    parameter DIG_RIGHT = 3'b011;
    parameter FALL_LEFT = 3'b100;
    parameter FALL_RIGHT = 3'b101;
    parameter SPLAT = 3'b110;

    reg [2:0] state;
    reg [4:0] fall_counter;

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_counter <= 0;
        end else begin
            case (state)
                WALK_LEFT, WALK_RIGHT: begin
                    if (!ground) begin
                        // Highest priority: falling
                        state <= (state == WALK_LEFT) ? FALL_LEFT : FALL_RIGHT;
                        fall_counter <= 1;
                    end else if (dig && ground) begin
                        // Middle priority: digging (only if on ground)
                        state <= (state == WALK_LEFT) ? DIG_LEFT : DIG_RIGHT;
                    end else if ((state == WALK_LEFT && (bump_left || (bump_left && bump_right))) begin
                        // Lowest priority: bumping
                        state <= WALK_RIGHT;
                    end else if ((state == WALK_RIGHT && (bump_right || (bump_left && bump_right))) begin
                        state <= WALK_LEFT;
                    end
                end
                
                DIG_LEFT, DIG_RIGHT: begin
                    if (!ground) begin
                        // Transition to falling when ground disappears
                        state <= (state == DIG_LEFT) ? FALL_LEFT : FALL_RIGHT;
                        fall_counter <= 1;
                    end
                end
                
                FALL_LEFT, FALL_RIGHT: begin
                    if (ground) begin
                        // Check splat condition when ground returns
                        if (fall_counter > 20) begin
                            state <= SPLAT;
                        end else begin
                            state <= (state == FALL_LEFT) ? WALK_LEFT : WALK_RIGHT;
                        end
                        fall_counter <= 0;
                    end else begin
                        fall_counter <= fall_counter + 1;
                    end
                end
                
                SPLAT: begin
                    // Stay in SPLAT state forever
                    state <= SPLAT;
                end
                
                default: begin
                    state <= WALK_LEFT;
                end
            endcase
        end
    end

    // Output logic
    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah = (state == FALL_LEFT || state == FALL_RIGHT);
    assign digging = (state == DIG_LEFT || state == DIG_RIGHT);

endmodule