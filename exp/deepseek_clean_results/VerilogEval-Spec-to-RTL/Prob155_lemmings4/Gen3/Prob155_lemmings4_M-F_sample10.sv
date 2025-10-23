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
    localparam [2:0] 
        LEFT    = 3'b000,
        RIGHT   = 3'b001,
        FALLING = 3'b010,
        DIGGING = 3'b011,
        SPLAT   = 3'b100;

    reg [2:0] state, next_state;
    reg direction; // 0=left, 1=right
    reg saved_dir;
    reg [4:0] fall_counter;

    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= LEFT;
            direction <= 0;
            saved_dir <= 0;
            fall_counter <= 0;
        end else begin
            state <= next_state;
            
            // Update direction
            if (state == LEFT || state == RIGHT) begin
                direction <= (next_state == LEFT) ? 0 : 
                             (next_state == RIGHT) ? 1 : direction;
            end
            
            // Save direction when starting to fall
            if ((state == LEFT || state == RIGHT) && next_state == FALLING) begin
                saved_dir <= direction;
            end
            
            // Update fall counter
            if (state == FALLING) begin
                fall_counter <= fall_counter + 1;
            end else begin
                fall_counter <= 0;
            end
        end
    end

    // Next state logic with strict priorities
    always @(*) begin
        case (state)
            LEFT, RIGHT: begin
                if (~ground) begin
                    next_state = FALLING;
                end else if (dig) begin
                    next_state = DIGGING;
                end else if ((state == LEFT && bump_left) || 
                           (state == RIGHT && bump_right)) begin
                    next_state = state == LEFT ? RIGHT : LEFT;
                end else begin
                    next_state = state;
                end
            end
            
            FALLING: begin
                if (ground) begin
                    next_state = (fall_counter > 20) ? SPLAT : 
                                (saved_dir ? RIGHT : LEFT);
                end else begin
                    next_state = FALLING;
                end
            end
            
            DIGGING: begin
                if (~ground) begin
                    next_state = FALLING;
                end else begin
                    next_state = DIGGING;
                end
            end
            
            SPLAT: next_state = SPLAT;
            
            default: next_state = LEFT;
        endcase
    end

    // Output logic - simple and direct
    assign walk_left = (state == LEFT) && (state != SPLAT);
    assign walk_right = (state == RIGHT) && (state != SPLAT);
    assign aaah = (state == FALLING);
    assign digging = (state == DIGGING);

endmodule