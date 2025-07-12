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

    // State encoding
    localparam [1:0]
        WALK = 2'b00,
        FALL = 2'b01,
        DIG  = 2'b10,
        SPLAT = 2'b11;

    reg [1:0] state, next_state;
    reg direction;  // 0=left, 1=right
    reg [4:0] fall_counter;

    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 0;  // start walking left
            fall_counter <= 0;
        end else begin
            state <= next_state;
            
            // Update direction only when walking and bumped
            if (state == WALK && next_state == WALK) begin
                if ((!direction && bump_left) || (direction && bump_right))
                    direction <= !direction;
            end
            
            // Update fall counter
            if (state == FALL) begin
                if (~ground) fall_counter <= fall_counter + 1;
            end else begin
                fall_counter <= 0;
            end
        end
    end

    // Next state logic with strict priority
    always @(*) begin
        case (state)
            WALK: begin
                if (~ground) begin
                    next_state = FALL;
                end else if (dig) begin
                    next_state = DIG;
                end else begin
                    next_state = WALK;
                end
            end
            
            FALL: begin
                if (ground) begin
                    next_state = (fall_counter > 20) ? SPLAT : WALK;
                end else begin
                    next_state = FALL;
                end
            end
            
            DIG: begin
                if (~ground) begin
                    next_state = FALL;
                end else begin
                    next_state = DIG;
                end
            end
            
            SPLAT: next_state = SPLAT;
            
            default: next_state = WALK;
        endcase
    end

    // Output logic - pure combinatorial
    assign walk_left = (state == WALK) & ~direction & ~(state == SPLAT);
    assign walk_right = (state == WALK) & direction & ~(state == SPLAT);
    assign aaah = (state == FALL);
    assign digging = (state == DIG);

endmodule