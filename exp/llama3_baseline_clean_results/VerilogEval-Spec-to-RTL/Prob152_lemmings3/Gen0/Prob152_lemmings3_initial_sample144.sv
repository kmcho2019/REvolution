module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // Define the states
    reg [1:0] state;
    reg [1:0] prev_state;

    localparam WALK_LEFT = 2'b00;
    localparam WALK_RIGHT = 2'b01;
    localparam FALLING = 2'b10;
    localparam DIGGING = 2'b11;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            prev_state <= WALK_LEFT;
        end else begin
            // Determine the next state
            case (state)
                WALK_LEFT: begin
                    if (!ground) begin
                        state <= FALLING;
                    end else if (bump_left) begin
                        state <= WALK_RIGHT;
                    end else if (dig && ground) begin
                        state <= DIGGING;
                    end else begin
                        state <= WALK_LEFT;
                    end
                end
                WALK_RIGHT: begin
                    if (!ground) begin
                        state <= FALLING;
                    end else if (bump_right) begin
                        state <= WALK_LEFT;
                    end else if (dig && ground) begin
                        state <= DIGGING;
                    end else begin
                        state <= WALK_RIGHT;
                    end
                end
                FALLING: begin
                    if (ground) begin
                        state <= prev_state;
                    end else begin
                        state <= FALLING;
                    end
                end
                DIGGING: begin
                    if (!ground) begin
                        state <= FALLING;
                    end else begin
                        state <= DIGGING;
                    end
                end
            endcase

            // Update the previous state
            if (state == FALLING || state == DIGGING) begin
                prev_state <= state;
            end else begin
                prev_state <= state;
            end
        end
    end

    // Determine the output variables
    always @(*) begin
        case (state)
            WALK_LEFT: begin
                walk_left = 1;
                walk_right = 0;
                aaah = 0;
                digging = 0;
            end
            WALK_RIGHT: begin
                walk_left = 0;
                walk_right = 1;
                aaah = 0;
                digging = 0;
            end
            FALLING: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 1;
                digging = 0;
            end
            DIGGING: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 0;
                digging = 1;
            end
        endcase
    end

endmodule