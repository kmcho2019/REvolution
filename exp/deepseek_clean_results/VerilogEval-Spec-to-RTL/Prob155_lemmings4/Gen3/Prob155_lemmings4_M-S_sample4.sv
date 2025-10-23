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
        WALK_LEFT  = 3'b000,
        WALK_RIGHT = 3'b001,
        FALLING    = 3'b010,
        DIGGING    = 3'b011,
        SPLATTERED = 3'b100;

    reg [2:0] state, next_state;
    reg [4:0] fall_counter;

    // State transition logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_counter <= 0;
        end else begin
            state <= next_state;
            
            // Update fall counter
            if (state == FALLING) begin
                fall_counter <= fall_counter + 1;
            end else begin
                fall_counter <= 0;
            end
        end
    end

    // Next state logic with clear priorities
    always @(*) begin
        case (state)
            WALK_LEFT: begin
                if (~ground) begin
                    next_state = FALLING;
                end else if (dig) begin
                    next_state = DIGGING;
                end else if (bump_left) begin
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = WALK_LEFT;
                end
            end
            
            WALK_RIGHT: begin
                if (~ground) begin
                    next_state = FALLING;
                end else if (dig) begin
                    next_state = DIGGING;
                end else if (bump_right) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end
            
            FALLING: begin
                if (ground) begin
                    next_state = (fall_counter > 20) ? SPLATTERED : 
                                (state == WALK_LEFT || (state == FALLING && fall_counter == 0)) ? WALK_LEFT : WALK_RIGHT;
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
            
            SPLATTERED: next_state = SPLATTERED;
            
            default: next_state = WALK_LEFT;
        endcase
    end

    // Simplified output logic
    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah = (state == FALLING);
    assign digging = (state == DIGGING);

endmodule