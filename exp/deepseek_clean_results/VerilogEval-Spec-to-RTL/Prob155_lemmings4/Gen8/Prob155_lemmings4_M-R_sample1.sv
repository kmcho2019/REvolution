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
    localparam SPLAT = 2'b11;

    reg [1:0] state, next_state;
    reg direction; // 0=left, 1=right
    reg [4:0] fall_cycles;

    // State transition
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 0;
            fall_cycles <= 0;
        end else begin
            state <= next_state;
            
            // Update direction only when walking on ground
            if (state == WALK && ground) begin
                if (bump_left) direction <= 1;
                if (bump_right) direction <= 0;
            end
            
            // Update fall timer
            if (state == FALL) begin
                fall_cycles <= ground ? 0 : fall_cycles + 1;
            end else begin
                fall_cycles <= 0;
            end
        end
    end

    // Next state logic (priority: fall > dig > walk)
    always @(*) begin
        case (state)
            WALK: begin
                if (~ground) next_state = FALL;
                else if (dig) next_state = DIG;
                else next_state = WALK;
            end
            
            FALL: begin
                if (ground) 
                    next_state = (fall_cycles > 20) ? SPLAT : WALK;
                else 
                    next_state = FALL;
            end
            
            DIG: begin
                if (~ground) next_state = FALL;
                else next_state = DIG;
            end
            
            SPLAT: next_state = SPLAT; // Permanent state
            
            default: next_state = WALK;
        endcase
    end

    // Output logic
    assign walk_left = (state == WALK) & ~direction & ~(state == SPLAT);
    assign walk_right = (state == WALK) & direction & ~(state == SPLAT);
    assign aaah = (state == FALL);
    assign digging = (state == DIG);

endmodule