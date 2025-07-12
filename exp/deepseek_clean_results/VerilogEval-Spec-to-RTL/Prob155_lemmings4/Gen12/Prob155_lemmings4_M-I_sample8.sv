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
    localparam WALK = 2'b00;
    localparam FALL = 2'b01;
    localparam DIG  = 2'b10;
    localparam SPLATTER = 2'b11;

    reg [1:0] state, next_state;
    reg direction; // 0=left, 1=right
    reg [4:0] fall_timer;

    // State transition
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 0; // start walking left
            fall_timer <= 0;
        end else begin
            state <= next_state;
            
            // Update direction only when walking and not transitioning to fall/dig
            if (state == WALK && next_state == WALK) begin
                case ({bump_left, bump_right})
                    2'b01: direction <= 1; // bump right -> walk left
                    2'b10: direction <= 0; // bump left -> walk right
                    2'b11: direction <= ~direction; // both bumps -> toggle
                    default: direction <= direction;
                endcase
            end
            
            // Update fall timer
            if (next_state == FALL) begin
                fall_timer <= (state != FALL) ? 1 : fall_timer + 1;
            end else begin
                fall_timer <= 0;
            end
        end
    end

    // Next state logic with strict priority
    always @(*) begin
        case (state)
            WALK: begin
                if (~ground) next_state = FALL; // highest priority
                else if (dig) next_state = DIG;
                else next_state = WALK;
            end
            
            FALL: begin
                if (ground)
                    next_state = (fall_timer > 20) ? SPLATTER : WALK;
                else
                    next_state = FALL;
            end
            
            DIG: begin
                if (~ground) next_state = FALL;
                else next_state = DIG;
            end
            
            SPLATTER: next_state = SPLATTER;
            
            default: next_state = WALK;
        endcase
    end

    // Consolidated output logic - single driver for each output
    assign {walk_left, walk_right, aaah, digging} = 
        (state == SPLATTER) ? 4'b0000 :
        (state == FALL) ? 4'b0001 :
        (state == DIG) ? 4'b0010 :
        (state == WALK && ~direction) ? 4'b1000 :
        (state == WALK && direction) ? 4'b0100 :
        4'b0000;

endmodule