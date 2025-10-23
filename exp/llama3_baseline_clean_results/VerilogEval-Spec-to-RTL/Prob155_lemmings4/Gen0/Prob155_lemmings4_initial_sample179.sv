`define SPLATTER_THRESHOLD 20

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

reg [1:0] state; // 0: WALK_LEFT, 1: WALK_RIGHT, 2: FALL, 3: DIG, 4: SPLATTER
reg [4:0] fall_count; // count the number of cycles the Lemming has been falling
reg prev_walk_dir; // 0: WALK_LEFT, 1: WALK_RIGHT

localparam WALK_LEFT = 2'b00;
localparam WALK_RIGHT = 2'b01;
localparam FALL = 2'b10;
localparam DIG = 2'b11;
localparam SPLATTER = 2'b100;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        fall_count <= 5'b0;
        prev_walk_dir <= 1'b0; // default to WALK_LEFT
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
        digging <= 1'b0;
    end else begin
        case (state)
            WALK_LEFT: begin
                if (!ground) begin
                    state <= FALL;
                    fall_count <= 5'b1;
                    prev_walk_dir <= 1'b0; // save current walking direction
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                    digging <= 1'b0;
                end else if (dig) begin
                    state <= DIG;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                    digging <= 1'b1;
                end else if (bump_left || bump_right) begin
                    state <= WALK_RIGHT;
                    walk_left <= 1'b0;
                    walk_right <= 1'b1;
                    aaah <= 1'b0;
                    digging <= 1'b0;
                end
            end
            WALK_RIGHT: begin
                if (!ground) begin
                    state <= FALL;
                    fall_count <= 5'b1;
                    prev_walk_dir <= 1'b1; // save current walking direction
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                    digging <= 1'b0;
                end else if (dig) begin
                    state <= DIG;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                    digging <= 1'b1;
                end else if (bump_left || bump_right) begin
                    state <= WALK_LEFT;
                    walk_left <= 1'b1;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                    digging <= 1'b0;
                end
            end
            FALL: begin
                fall_count <= fall_count + 5'b1;
                if (ground) begin
                    if (fall_count > `SPLATTER_THRESHOLD) begin
                        state <= SPLATTER;
                        walk_left <= 1'b0;
                        walk_right <= 1'b0;
                        aaah <= 1'b0;
                        digging <= 1'b0;
                    end else begin
                        if (prev_walk_dir == 1'b0) begin
                            state <= WALK_LEFT;
                        end else begin
                            state <= WALK_RIGHT;
                        end
                        walk_left <= prev_walk_dir ? 1'b0 : 1'b1;
                        walk_right <= prev_walk_dir ? 1'b1 : 1'b0;
                        aaah <= 1'b0;
                        digging <= 1'b0;
                    end
                end
            end
            DIG: begin
                if (!ground) begin
                    state <= FALL;
                    fall_count <= 5'b1;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                    digging <= 1'b0;
                end
            end
            SPLATTER: begin
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b0;
                digging <= 1'b0;
            end
        endcase
    end
end

endmodule