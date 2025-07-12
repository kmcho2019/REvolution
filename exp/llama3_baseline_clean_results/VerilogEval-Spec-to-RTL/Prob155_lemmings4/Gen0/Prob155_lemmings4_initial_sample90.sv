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

// State definitions
localparam WALKING_LEFT = 3'b001;
localparam WALKING_RIGHT = 3'b010;
localparam FALLING = 3'b011;
localparam DIGGING = 3'b100;
localparam SPLATTERED = 3'b111;

// State register
reg [2:0] state;
reg [5:0] fall_counter;

// Next state logic
always @ (posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING_LEFT;
        fall_counter <= 0;
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
        digging <= 1'b0;
    end else begin
        case (state)
            WALKING_LEFT: begin
                if (!ground) begin
                    state <= FALLING;
                    fall_counter <= 1;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                    digging <= 1'b0;
                end else if (dig) begin
                    state <= DIGGING;
                    fall_counter <= 0;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                    digging <= 1'b1;
                end else if (bump_right) begin
                    state <= WALKING_RIGHT;
                    fall_counter <= 0;
                    walk_left <= 1'b0;
                    walk_right <= 1'b1;
                    aaah <= 1'b0;
                    digging <= 1'b0;
                end else begin
                    state <= WALKING_LEFT;
                    fall_counter <= 0;
                    walk_left <= 1'b1;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                    digging <= 1'b0;
                end
            end
            WALKING_RIGHT: begin
                if (!ground) begin
                    state <= FALLING;
                    fall_counter <= 1;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                    digging <= 1'b0;
                end else if (dig) begin
                    state <= DIGGING;
                    fall_counter <= 0;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                    digging <= 1'b1;
                end else if (bump_left) begin
                    state <= WALKING_LEFT;
                    fall_counter <= 0;
                    walk_left <= 1'b1;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                    digging <= 1'b0;
                end else begin
                    state <= WALKING_RIGHT;
                    fall_counter <= 0;
                    walk_left <= 1'b0;
                    walk_right <= 1'b1;
                    aaah <= 1'b0;
                    digging <= 1'b0;
                end
            end
            FALLING: begin
                fall_counter <= fall_counter + 1;
                if (ground) begin
                    if (fall_counter > 20) begin
                        state <= SPLATTERED;
                        walk_left <= 1'b0;
                        walk_right <= 1'b0;
                        aaah <= 1'b0;
                        digging <= 1'b0;
                    end else if (state == WALKING_LEFT) begin
                        state <= WALKING_LEFT;
                        walk_left <= 1'b1;
                        walk_right <= 1'b0;
                        aaah <= 1'b0;
                        digging <= 1'b0;
                    end else begin
                        state <= WALKING_RIGHT;
                        walk_left <= 1'b0;
                        walk_right <= 1'b1;
                        aaah <= 1'b0;
                        digging <= 1'b0;
                    end
                end else begin
                    state <= FALLING;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                    digging <= 1'b0;
                end
            end
            DIGGING: begin
                if (!ground) begin
                    state <= FALLING;
                    fall_counter <= 1;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                    digging <= 1'b0;
                end else begin
                    state <= DIGGING;
                    fall_counter <= 0;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                    digging <= 1'b1;
                end
            end
            SPLATTERED: begin
                state <= SPLATTERED;
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b0;
                digging <= 1'b0;
            end
        endcase
    end
end

endmodule