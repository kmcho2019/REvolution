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

// Define states
reg [1:0] state;
localparam IDLE_LEFT = 2'b00;
localparam IDLE_RIGHT = 2'b01;
localparam DIGGING = 2'b10;
localparam FALLING = 2'b11;

// Initialize state
initial state = IDLE_LEFT;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset
        state <= IDLE_LEFT;
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
        digging <= 1'b0;
    end else begin
        case (state)
            IDLE_LEFT: begin
                if (~ground) begin
                    // Ground disappeared, enter falling state
                    state <= FALLING;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                    digging <= 1'b0;
                end else if (dig) begin
                    // Start digging
                    state <= DIGGING;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                    digging <= 1'b1;
                end else if (bump_right) begin
                    // Bump from right, switch direction
                    state <= IDLE_RIGHT;
                    walk_left <= 1'b0;
                    walk_right <= 1'b1;
                    aaah <= 1'b0;
                    digging <= 1'b0;
                end else if (bump_left) begin
                    // Do nothing, already walking left
                end else begin
                    // Stay in current state
                end
            end
            IDLE_RIGHT: begin
                if (~ground) begin
                    // Ground disappeared, enter falling state
                    state <= FALLING;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                    digging <= 1'b0;
                end else if (dig) begin
                    // Start digging
                    state <= DIGGING;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                    digging <= 1'b1;
                end else if (bump_left) begin
                    // Bump from left, switch direction
                    state <= IDLE_LEFT;
                    walk_left <= 1'b1;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                    digging <= 1'b0;
                end else if (bump_right) begin
                    // Do nothing, already walking right
                end else begin
                    // Stay in current state
                end
            end
            DIGGING: begin
                if (~ground) begin
                    // Ground disappeared, enter falling state
                    state <= FALLING;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                    digging <= 1'b0;
                end else begin
                    // Stay in digging state
                end
            end
            FALLING: begin
                if (ground) begin
                    // Ground reappeared, exit falling state
                    if (state == FALLING) begin
                        // Determine previous direction
                        if (bump_right) begin
                            state <= IDLE_LEFT;
                            walk_left <= 1'b1;
                            walk_right <= 1'b0;
                            aaah <= 1'b0;
                            digging <= 1'b0;
                        end else if (bump_left) begin
                            state <= IDLE_RIGHT;
                            walk_left <= 1'b0;
                            walk_right <= 1'b1;
                            aaah <= 1'b0;
                            digging <= 1'b0;
                        end else begin
                            // No bump, restore previous direction
                            if (state == IDLE_LEFT) begin
                                state <= IDLE_LEFT;
                                walk_left <= 1'b1;
                                walk_right <= 1'b0;
                                aaah <= 1'b0;
                                digging <= 1'b0;
                            end else if (state == IDLE_RIGHT) begin
                                state <= IDLE_RIGHT;
                                walk_left <= 1'b0;
                                walk_right <= 1'b1;
                                aaah <= 1'b0;
                                digging <= 1'b0;
                            end else begin
                                // Default to idle left
                                state <= IDLE_LEFT;
                                walk_left <= 1'b1;
                                walk_right <= 1'b0;
                                aaah <= 1'b0;
                                digging <= 1'b0;
                            end
                        end
                    end else begin
                        // Do nothing
                    end
                end else begin
                    // Stay in falling state
                end
            end
            default: begin
                // Do nothing
            end
        endcase
    end
end

endmodule