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

    // One-hot states
    parameter WALK_LEFT  = 2'b00;
    parameter WALK_RIGHT = 2'b01;
    parameter FALL_LEFT  = 2'b10;
    parameter FALL_RIGHT = 2'b11;

    reg [1:0] state;
    reg dig_active;

    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            dig_active <= 0;
        end
        else begin
            case (state)
                WALK_LEFT, WALK_RIGHT: begin
                    if (!ground) begin
                        state <= (state == WALK_LEFT) ? FALL_LEFT : FALL_RIGHT;
                        dig_active <= 0;
                    end
                    else if (dig) begin
                        dig_active <= 1;
                    end
                end
                
                FALL_LEFT, FALL_RIGHT: begin
                    if (ground) begin
                        state <= (state == FALL_LEFT) ? WALK_LEFT : WALK_RIGHT;
                        dig_active <= 0;
                    end
                end
            endcase
        end
    end

    // Direction change logic (only when walking and not digging)
    always @(posedge clk) begin
        if (!areset && (state == WALK_LEFT || state == WALK_RIGHT) && ground && !dig_active) begin
            if (bump_left)  state <= WALK_RIGHT;
            if (bump_right) state <= WALK_LEFT;
        end
    end

    // Output logic
    assign walk_left  = (state == WALK_LEFT)  && !dig_active;
    assign walk_right = (state == WALK_RIGHT) && !dig_active;
    assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);
    assign digging    = ((state == WALK_LEFT) || (state == WALK_RIGHT)) && dig_active;

endmodule