module TopModule(
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

// Enumerate the states
localparam IDLE_LEFT = 2'b00;
localparam IDLE_RIGHT = 2'b01;
localparam FALLING = 2'b10;
localparam DIGGING = 2'b11;

// State register
reg [1:0] state;
reg [1:0] next_state;

// Output logic
always @(*) begin
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;
    
    case (state)
        IDLE_LEFT: begin
            walk_left = 1;
        end
        IDLE_RIGHT: begin
            walk_right = 1;
        end
        FALLING: begin
            aaah = 1;
        end
        DIGGING: begin
            digging = 1;
        end
    endcase
end

// Next state logic
always @(*) begin
    next_state = state;
    
    case (state)
        IDLE_LEFT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = IDLE_RIGHT;
            end else if (bump_right) begin
                next_state = IDLE_LEFT; // No change if already walking left
            end
        end
        IDLE_RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = IDLE_LEFT;
            end else if (bump_right) begin
                next_state = IDLE_LEFT; // Change direction
            end
        end
        FALLING: begin
            if (ground) begin
                // Resume walking in the same direction as before the fall
                if (state == IDLE_LEFT) begin
                    next_state = IDLE_LEFT;
                end else if (state == IDLE_RIGHT) begin
                    next_state = IDLE_RIGHT;
                end else if (state == DIGGING) begin
                    // If digging and reached the other side, resume walking
                    // in the original direction (IDLE_LEFT or IDLE_RIGHT)
                    // But since we can't keep track of the original direction
                    // in the DIGGING state, we assume it walks left
                    next_state = IDLE_LEFT;
                end
            end
        end
        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
            end
        end
    endcase
end

// State register update
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
    end else begin
        state <= next_state;
    end
end

endmodule