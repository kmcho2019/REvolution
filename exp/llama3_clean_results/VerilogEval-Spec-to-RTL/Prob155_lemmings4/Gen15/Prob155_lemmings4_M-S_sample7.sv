module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

// Enum for modes
enum logic [1:0] {WALK, FALL, DIG, STOP} mode;

// Current mode
reg [1:0] current_mode;

// Walking sub-module
reg walking_direction;

// Falling sub-module
reg [4:0] fall_count;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_mode <= WALK;
        walking_direction <= 1'b0; // walking left
        fall_count <= 5'b0;
    end else begin
        case (current_mode)
            WALK: begin
                if (!ground) begin
                    current_mode <= FALL;
                    fall_count <= 5'b0;
                end else if (dig) begin
                    current_mode <= DIG;
                end else if (bump_left || bump_right) begin
                    walking_direction <= ~walking_direction;
                end
            end
            FALL: begin
                if (ground) begin
                    if (fall_count > 5'd20) begin
                        current_mode <= STOP;
                    end else begin
                        current_mode <= WALK;
                    end
                end else begin
                    fall_count <= fall_count + 1'b1;
                end
            end
            DIG: begin
                if (!ground) begin
                    current_mode <= FALL;
                    fall_count <= 5'b0;
                end
            end
            STOP: begin
                // Do nothing
            end
        endcase
    end
end

always @(posedge clk) begin
    case (current_mode)
        WALK: begin
            walk_left <= ~walking_direction;
            walk_right <= walking_direction;
            aaah <= 1'b0;
            digging <= 1'b0;
        end
        FALL: begin
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b1;
            digging <= 1'b0;
        end
        DIG: begin
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b0;
            digging <= 1'b1;
        end
        STOP: begin
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b0;
            digging <= 1'b0;
        end
    endcase
end

endmodule