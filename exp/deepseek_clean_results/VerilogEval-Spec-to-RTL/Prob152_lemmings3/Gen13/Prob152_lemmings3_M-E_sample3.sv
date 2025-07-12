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

    // Movement states
    parameter M_WALK = 2'b00;
    parameter M_FALL = 2'b01;
    parameter M_DIG  = 2'b10;

    // Direction states
    parameter D_LEFT  = 1'b0;
    parameter D_RIGHT = 1'b1;

    reg [1:0] movement_state;
    reg direction;
    reg next_direction; // Buffers direction changes during walking

    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            movement_state <= M_WALK;
            direction <= D_LEFT;
            next_direction <= D_LEFT;
        end
        else begin
            // Movement state transitions (highest priority first)
            case (movement_state)
                M_WALK: begin
                    if (!ground) begin
                        movement_state <= M_FALL;
                    end
                    else if (dig) begin
                        movement_state <= M_DIG;
                    end
                    else begin
                        // Apply buffered direction changes
                        direction <= next_direction;
                    end
                end

                M_FALL: if (ground) movement_state <= M_WALK;
                
                M_DIG: if (!ground) movement_state <= M_FALL;
            endcase

            // Buffer direction changes (only while walking)
            if (movement_state == M_WALK && ground && !dig) begin
                if (bump_left) next_direction <= D_RIGHT;
                else if (bump_right) next_direction <= D_LEFT;
            end
        end
    end

    // Output logic
    assign walk_left  = (movement_state == M_WALK) && (direction == D_LEFT);
    assign walk_right = (movement_state == M_WALK) && (direction == D_RIGHT);
    assign aaah       = (movement_state == M_FALL);
    assign digging    = (movement_state == M_DIG);

endmodule