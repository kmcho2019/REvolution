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

    // Main states
    typedef enum logic [1:0] {
        WALK,
        FALL,
        DIG,
        SPLATTER
    } state_t;
    
    state_t state, next_state;
    reg direction; // 0=left, 1=right
    reg [4:0] fall_cycles;
    reg timer_clear;

    // Direction update logic (only during walking state)
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            direction <= 0; // start left
        end else if (state == WALK && next_state == WALK) begin
            case ({bump_left, bump_right})
                2'b01: direction <= 1; // bump right -> walk left
                2'b10: direction <= 0; // bump left -> walk right
                2'b11: direction <= ~direction; // both bumps -> toggle
                default: direction <= direction;
            endcase
        end
    end

    // Fall timer logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            fall_cycles <= 0;
        end else if (timer_clear) begin
            fall_cycles <= 0;
        end else if (state == FALL) begin
            fall_cycles <= fall_cycles + 1;
        end
    end

    // State transition logic
    always @(*) begin
        next_state = state;
        timer_clear = 0;
        
        case (state)
            WALK: begin
                if (~ground) begin
                    next_state = FALL;
                    timer_clear = 0;
                end else if (dig) begin
                    next_state = DIG;
                end
            end
            
            FALL: begin
                if (ground) begin
                    next_state = (fall_cycles > 20) ? SPLATTER : WALK;
                    timer_clear = 1;
                end
            end
            
            DIG: begin
                if (~ground) begin
                    next_state = FALL;
                    timer_clear = 0;
                end
            end
            
            SPLATTER: begin
                next_state = SPLATTER;
            end
        endcase
    end

    // State register
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
        end else begin
            state <= next_state;
        end
    end

    // Single-source output logic
    assign {walk_left, walk_right, aaah, digging} = 
        (state == SPLATTER) ? 4'b0000 :
        (state == FALL) ? {1'b0, 1'b0, 1'b1, 1'b0} :
        (state == DIG) ? {1'b0, 1'b0, 1'b0, 1'b1} :
        {~direction, direction, 1'b0, 1'b0}; // WALK state

endmodule