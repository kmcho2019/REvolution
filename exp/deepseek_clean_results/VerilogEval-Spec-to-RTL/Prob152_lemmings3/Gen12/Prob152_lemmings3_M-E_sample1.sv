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
    typedef enum logic [1:0] {
        WALKING,
        FALLING,
        DIGGING
    } state_t;

    reg [1:0] state, next_state;
    reg direction;      // 1=left, 0=right
    reg pending_dir;    // remembers direction during fall/dig

    // State transition logic
    always @(*) begin
        case (state)
            WALKING: begin
                if (~ground) begin
                    next_state = FALLING;
                end else if (dig) begin
                    next_state = DIGGING;
                end else begin
                    next_state = WALKING;
                end
            end
            FALLING: begin
                next_state = ground ? WALKING : FALLING;
            end
            DIGGING: begin
                next_state = ground ? DIGGING : FALLING;
            end
            default: next_state = WALKING;
        endcase
    end

    // Direction update logic (only when walking)
    always @(*) begin
        if (state == WALKING) begin
            case ({bump_left, bump_right})
                2'b10:   direction = 0; // go right
                2'b01:   direction = 1; // go left
                2'b11:   direction = ~direction; // toggle
                default: direction = direction; // hold
            endcase
        end
    end

    // Sequential logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALKING;
            direction <= 1;
            pending_dir <= 1;
        end else begin
            state <= next_state;
            
            // Update pending direction when entering fall/dig
            if (state == WALKING && next_state != WALKING) begin
                pending_dir <= direction;
            end
            
            // Restore direction when landing from fall
            if (state == FALLING && next_state == WALKING) begin
                direction <= pending_dir;
            end
        end
    end

    // Output logic
    assign walk_left = (state == WALKING) & direction;
    assign walk_right = (state == WALKING) & ~direction;
    assign aaah = (state == FALLING);
    assign digging = (state == DIGGING);

endmodule