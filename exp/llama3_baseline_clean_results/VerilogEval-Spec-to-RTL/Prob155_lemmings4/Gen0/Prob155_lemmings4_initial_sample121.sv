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
parameter WALK_LEFT = 4'd0;
parameter WALK_RIGHT = 4'd1;
parameter FALLING = 4'd2;
parameter DIGGING = 4'd3;
parameter SPLATTERED = 4'd4;

reg [3:0] state;
reg [5:0] fall_count; // count the number of clock cycles the Lemming has been falling

always @ (posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        fall_count <= 0;
    end else begin
        case (state)
            WALK_LEFT: begin
                if (!ground) begin
                    state <= FALLING;
                    fall_count <= 1;
                end else if (dig && ground) begin
                    state <= DIGGING;
                end else if (bump_left) begin
                    state <= WALK_RIGHT;
                end else if (bump_right) begin
                    state <= WALK_LEFT;
                end
            end
            WALK_RIGHT: begin
                if (!ground) begin
                    state <= FALLING;
                    fall_count <= 1;
                end else if (dig && ground) begin
                    state <= DIGGING;
                end else if (bump_left) begin
                    state <= WALK_LEFT;
                end else if (bump_right) begin
                    state <= WALK_LEFT;
                end
            end
            FALLING: begin
                if (ground) begin
                    if (fall_count > 20) begin
                        state <= SPLATTERED;
                    end else if (state == WALK_LEFT) begin
                        state <= WALK_LEFT;
                    end else if (state == WALK_RIGHT) begin
                        state <= WALK_RIGHT;
                    end
                end else begin
                    fall_count <= fall_count + 1;
                end
            end
            DIGGING: begin
                if (!ground) begin
                    state <= FALLING;
                    fall_count <= 1;
                end
            end
            SPLATTERED: begin
                // do nothing
            end
        endcase
    end
end

// Output logic
always @ (*) begin
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
        SPLATTERED: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
    endcase
end

endmodule