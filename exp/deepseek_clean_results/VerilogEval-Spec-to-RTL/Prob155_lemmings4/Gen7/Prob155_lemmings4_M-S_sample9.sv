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

    // States
    parameter WALK  = 2'b00;
    parameter FALL  = 2'b01;
    parameter DIG   = 2'b10;
    parameter SPLAT = 2'b11;
    reg [1:0] state, next_state;

    // Direction (0=left, 1=right)
    reg direction;

    // Fall duration counter
    reg [4:0] fall_counter;

    // State transition logic
    always @(*) begin
        case (state)
            WALK: begin
                if (!ground) 
                    next_state = FALL;
                else if (dig) 
                    next_state = DIG;
                else 
                    next_state = WALK;
            end
            FALL: begin
                if (ground) 
                    next_state = (fall_counter > 20) ? SPLAT : WALK;
                else 
                    next_state = FALL;
            end
            DIG: begin
                if (!ground) 
                    next_state = FALL;
                else 
                    next_state = DIG;
            end
            SPLAT: next_state = SPLAT;
            default: next_state = WALK;
        endcase
    end

    // Sequential logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 0; // start walking left
            fall_counter <= 0;
        end else begin
            state <= next_state;
            
            // Update direction only when walking and not changing to another state
            if (state == WALK && next_state == WALK) begin
                case ({bump_left, bump_right})
                    2'b10: direction <= 1; // right
                    2'b01: direction <= 0; // left
                    2'b11: direction <= ~direction; // toggle if both bumps
                    default: direction <= direction;
                endcase
            end
            
            // Update fall counter
            if (state == FALL) begin
                if (!ground) 
                    fall_counter <= fall_counter + 1;
                else 
                    fall_counter <= 0;
            end else begin
                fall_counter <= 0;
            end
        end
    end

    // Output logic
    assign walk_left  = (state == WALK) && !direction;
    assign walk_right = (state == WALK) && direction;
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule