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

reg [2:0] state; // 3-bit state variable
reg [4:0] fall_counter; // 5-bit counter to count falling clock cycles
reg prev_ground; // to track previous ground value

localparam WALK_LEFT = 3'b001;
localparam WALK_RIGHT = 3'b010;
localparam FALLING = 3'b011;
localparam DIGGING = 3'b100;
localparam SPLATTERED = 3'b000;

always @ (posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        fall_counter <= 5'b0;
        prev_ground <= 1'b1;
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
        digging <= 1'b0;
    end else begin
        case (state)
            WALK_LEFT: begin
                if (!ground) begin
                    state <= FALLING;
                    fall_counter <= 5'b1;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                    digging <= 1'b0;
                end else if (dig) begin
                    state <= DIGGING;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                    digging <= 1'b1;
                end else if (bump_left) begin
                    state <= WALK_RIGHT;
                    walk_left <= 1'b0;
                    walk_right <= 1'b1;
                    aaah <= 1'b0;
                    digging <= 1'b0;
                end else if (bump_right) begin
                    // do nothing, already walking left
                end else begin
                    // do nothing, keep walking left
                end
            end
            WALK_RIGHT: begin
                if (!ground) begin
                    state <= FALLING;
                    fall_counter <= 5'b1;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                    digging <= 1'b0;
                end else if (dig) begin
                    state <= DIGGING;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                    digging <= 1'b1;
                end else if (bump_right) begin
                    state <= WALK_LEFT;
                    walk_left <= 1'b1;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                    digging <= 1'b0;
                end else if (bump_left) begin
                    // do nothing, already walking right
                end else begin
                    // do nothing, keep walking right
                end
            end
            FALLING: begin
                if (ground) begin
                    if (fall_counter > 5'b10100) begin
                        state <= SPLATTERED;
                        walk_left <= 1'b0;
                        walk_right <= 1'b0;
                        aaah <= 1'b0;
                        digging <= 1'b0;
                    end else begin
                        if (prev_ground) begin
                            walk_left <= 1'b1;
                            walk_right <= 1'b0;
                            aaah <= 1'b0;
                            digging <= 1'b0;
                        end else begin
                            walk_left <= 1'b0;
                            walk_right <= 1'b1;
                            aaah <= 1'b0;
                            digging <= 1'b0;
                        end
                        state <= WALK_LEFT;
                    end
                end else begin
                    fall_counter <= fall_counter + 1'b1;
                end
            end
            DIGGING: begin
                if (!ground) begin
                    state <= FALLING;
                    fall_counter <= 5'b1;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                    digging <= 1'b0;
                end else begin
                    // continue digging
                end
            end
            SPLATTERED: begin
                // do nothing, stay splattered
            end
            default: begin
                state <= WALK_LEFT;
                walk_left <= 1'b1;
                walk_right <= 1'b0;
                aaah <= 1'b0;
                digging <= 1'b0;
            end
        endcase
        prev_ground <= ground;
    end
end

endmodule