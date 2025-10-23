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

// Top-level FSM states
localparam IDLE = 2'd0;
localparam WALKING = 2'd1;
localparam FALLING = 2'd2;
localparam SPLATTERED = 2'd3;

// Walking sub-FSM states
localparam WALKING_LEFT = 2'd0;
localparam WALKING_RIGHT = 2'd1;
localparam DIGGING = 2'd2;

reg [1:0] top_state;
reg [1:0] walk_state;
reg [4:0] fall_counter;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        top_state <= IDLE;
        walk_state <= WALKING_LEFT;
        fall_counter <= 5'd0;
    end else begin
        case (top_state)
            IDLE: begin
                if (ground) begin
                    top_state <= WALKING;
                end
            end
            WALKING: begin
                if (!ground) begin
                    top_state <= FALLING;
                    fall_counter <= 1;
                end
            end
            FALLING: begin
                fall_counter <= fall_counter + 1;
                if (ground) begin
                    if (fall_counter > 5'd20) begin
                        top_state <= SPLATTERED;
                    end else begin
                        top_state <= WALKING;
                    end
                end
            end
            SPLATTERED: begin
                top_state <= SPLATTERED;
            end
        endcase

        case (walk_state)
            WALKING_LEFT: begin
                if (bump_left) begin
                    walk_state <= WALKING_RIGHT;
                end else if (bump_right) begin
                    // No change
                end else if (dig) begin
                    walk_state <= DIGGING;
                end
            end
            WALKING_RIGHT: begin
                if (bump_left) begin
                    walk_state <= WALKING_LEFT;
                end else if (bump_right) begin
                    // No change
                end else if (dig) begin
                    walk_state <= DIGGING;
                end
            end
            DIGGING: begin
                if (!ground) begin
                    walk_state <= WALKING_LEFT;
                    top_state <= FALLING;
                    fall_counter <= 1;
                end
            end
        endcase
    end
end

always @(posedge clk) begin
    case (top_state)
        WALKING: begin
            case (walk_state)
                WALKING_LEFT: begin
                    walk_left <= 1;
                    walk_right <= 0;
                    aaah <= 0;
                    digging <= 0;
                end
                WALKING_RIGHT: begin
                    walk_left <= 0;
                    walk_right <= 1;
                    aaah <= 0;
                    digging <= 0;
                end
                DIGGING: begin
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 0;
                    digging <= 1;
                end
            endcase
        end
        FALLING: begin
            walk_left <= 0;
            walk_right <= 0;
            aaah <= 1;
            digging <= 0;
        end
        SPLATTERED: begin
            walk_left <= 0;
            walk_right <= 0;
            aaah <= 0;
            digging <= 0;
        end
    endcase
end

endmodule