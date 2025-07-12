module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

reg [4:0] fall_count;
reg [2:0] state; // 0: IDLE_LEFT, 1: IDLE_RIGHT, 2: FALLING, 3: DIGGING_LEFT, 4: DIGGING_RIGHT, 5: SPLATTERED

// Define the states
localparam IDLE_LEFT = 3'b000;
localparam IDLE_RIGHT = 3'b001;
localparam FALLING = 3'b010;
localparam DIGGING_LEFT = 3'b011;
localparam DIGGING_RIGHT = 3'b100;
localparam SPLATTERED = 3'b101;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
        fall_count <= 0;
        walk_left <= 1;
        walk_right <= 0;
        aaah <= 0;
        digging <= 0;
    end else begin
        case (state)
            IDLE_LEFT: begin
                if (!ground) begin
                    state <= FALLING;
                    fall_count <= 1;
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 1;
                    digging <= 0;
                end else if (dig) begin
                    state <= DIGGING_LEFT;
                    walk_left <= 1;
                    walk_right <= 0;
                    aaah <= 0;
                    digging <= 1;
                end else if (bump_left) begin
                    state <= IDLE_RIGHT;
                    walk_left <= 0;
                    walk_right <= 1;
                    aaah <= 0;
                    digging <= 0;
                end else if (bump_right) begin
                    // no need to change state
                end else begin
                    // no need to change state
                end
            end
            IDLE_RIGHT: begin
                if (!ground) begin
                    state <= FALLING;
                    fall_count <= 1;
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 1;
                    digging <= 0;
                end else if (dig) begin
                    state <= DIGGING_RIGHT;
                    walk_left <= 0;
                    walk_right <= 1;
                    aaah <= 0;
                    digging <= 1;
                end else if (bump_right) begin
                    state <= IDLE_LEFT;
                    walk_left <= 1;
                    walk_right <= 0;
                    aaah <= 0;
                    digging <= 0;
                end else if (bump_left) begin
                    // no need to change state
                end else begin
                    // no need to change state
                end
            end
            FALLING: begin
                fall_count <= fall_count + 1;
                if (ground) begin
                    if (fall_count > 20) begin
                        state <= SPLATTERED;
                        walk_left <= 0;
                        walk_right <= 0;
                        aaah <= 0;
                        digging <= 0;
                    end else if (state == IDLE_LEFT) begin
                        state <= IDLE_LEFT;
                        walk_left <= 1;
                        walk_right <= 0;
                        aaah <= 0;
                        digging <= 0;
                    end else begin
                        state <= IDLE_RIGHT;
                        walk_left <= 0;
                        walk_right <= 1;
                        aaah <= 0;
                        digging <= 0;
                    end
                end else begin
                    // no need to change state
                end
            end
            DIGGING_LEFT: begin
                if (!ground) begin
                    state <= FALLING;
                    fall_count <= 1;
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 1;
                    digging <= 0;
                end else begin
                    // no need to change state
                end
            end
            DIGGING_RIGHT: begin
                if (!ground) begin
                    state <= FALLING;
                    fall_count <= 1;
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 1;
                    digging <= 0;
                end else begin
                    // no need to change state
                end
            end
            SPLATTERED: begin
                // no need to change state
            end
            default: begin
                state <= IDLE_LEFT;
                walk_left <= 1;
                walk_right <= 0;
                aaah <= 0;
                digging <= 0;
            end
        endcase
    end
end
endmodule