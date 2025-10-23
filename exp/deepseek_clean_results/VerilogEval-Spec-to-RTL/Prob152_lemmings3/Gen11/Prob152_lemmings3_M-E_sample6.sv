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

    // Hierarchical state encoding (one-hot)
    parameter FALLING = 3'b100;
    parameter WALK_L  = 3'b010;
    parameter WALK_R  = 3'b001;
    parameter DIGGING = 3'b000; // Special case - uses direction bit

    reg [2:0] state;
    reg direction; // 0=left, 1=right (used for DIGGING state)
    reg ground_prev;
    wire ground_falling_edge = ground_prev & ~ground;
    wire ground_rising_edge = ~ground_prev & ground;

    // Track previous ground for edge detection
    always @(posedge clk or posedge areset) begin
        if (areset) ground_prev <= 1;
        else ground_prev <= ground;
    end

    // Main state machine
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_L;
            direction <= 0;
        end
        else begin
            case (state)
                FALLING: begin
                    if (ground_rising_edge) begin
                        state <= direction ? WALK_R : WALK_L;
                    end
                end
                
                WALK_L, WALK_R: begin
                    if (ground_falling_edge) begin
                        state <= FALLING;
                    end
                    else if (ground && dig) begin
                        state <= DIGGING;
                        direction <= (state == WALK_R);
                    end
                    else if (ground) begin
                        // Bump handling only when grounded
                        if (bump_left && (state == WALK_L)) begin
                            state <= WALK_R;
                        end
                        else if (bump_right && (state == WALK_R)) begin
                            state <= WALK_L;
                        end
                    end
                end
                
                DIGGING: begin
                    if (ground_falling_edge) begin
                        state <= FALLING;
                    end
                end
            endcase
        end
    end

    // Output logic
    assign walk_left  = (state == WALK_L);
    assign walk_right = (state == WALK_R);
    assign aaah       = (state == FALLING);
    assign digging    = (state == DIGGING);

endmodule