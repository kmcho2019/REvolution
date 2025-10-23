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

// Digging sub-module
reg digging_enable;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_mode <= WALK;
        walking_direction <= 1'b0; // walking left
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        digging <= 1'b0;
        aaah <= 1'b0;
        fall_count <= 5'b0;
        digging_enable <= 1'b0;
    end else begin
        case (current_mode)
            WALK: begin
                if (!ground) begin
                    current_mode <= FALL;
                    fall_count <= 5'b0;
                end else if (dig) begin
                    current_mode <= DIG;
                    digging_enable <= 1'b1;
                end else if (bump_left || bump_right) begin
                    walking_direction <= ~walking_direction;
                end
            end
            FALL: begin
                if (ground) begin
                    if (fall_count > 5'd20) begin
                        current_mode <= STOP;
                        walk_left <= 1'b0;
                        walk_right <= 1'b0;
                        digging <= 1'b0;
                        aaah <= 1'b0;
                    end else begin
                        current_mode <= WALK;
                        if (walking_direction == 1'b0) begin
                            walk_left <= 1'b1;
                            walk_right <= 1'b0;
                        end else begin
                            walk_left <= 1'b0;
                            walk_right <= 1'b1;
                        end
                    end
                end else begin
                    fall_count <= fall_count + 1'b1;
                end
            end
            DIG: begin
                if (!ground) begin
                    current_mode <= FALL;
                    fall_count <= 5'b0;
                    digging_enable <= 1'b0;
                end
            end
            STOP: begin
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                digging <= 1'b0;
                aaah <= 1'b0;
            end
        endcase
    end
end

always @(posedge clk) begin
    case (current_mode)
        WALK: begin
            walk_left <= ~walking_direction;
            walk_right <= walking_direction;
            digging <= 1'b0;
            aaah <= 1'b0;
        end
        FALL: begin
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            digging <= 1'b0;
            aaah <= 1'b1;
        end
        DIG: begin
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            digging <= digging_enable;
            aaah <= 1'b0;
        end
        STOP: begin
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            digging <= 1'b0;
            aaah <= 1'b0;
        end
    endcase
end

endmodule