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

// Define the states
parameter WALK_LEFT = 4'b0000;
parameter WALK_RIGHT = 4'b0001;
parameter FALLING = 4'b0010;
parameter DIGGING = 4'b0011;
parameter SPLATTERED = 4'b0100;

reg [3:0] state;
reg [4:0] fall_counter;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        fall_counter <= 0;
        walk_left <= 1;
        walk_right <= 0;
        aaah <= 0;
        digging <= 0;
    end else begin
        case (state)
            WALK_LEFT: begin
                if (ground == 0) begin
                    state <= FALLING;
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 1;
                    digging <= 0;
                end else if (dig == 1) begin
                    state <= DIGGING;
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 0;
                    digging <= 1;
                end else if (bump_left == 1) begin
                    state <= WALK_RIGHT;
                    walk_left <= 0;
                    walk_right <= 1;
                    aaah <= 0;
                    digging <= 0;
                end else if (bump_right == 0) begin
                    walk_left <= 1;
                    walk_right <= 0;
                    aaah <= 0;
                    digging <= 0;
                end
            end
            WALK_RIGHT: begin
                if (ground == 0) begin
                    state <= FALLING;
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 1;
                    digging <= 0;
                end else if (dig == 1) begin
                    state <= DIGGING;
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 0;
                    digging <= 1;
                end else if (bump_right == 1) begin
                    state <= WALK_LEFT;
                    walk_left <= 1;
                    walk_right <= 0;
                    aaah <= 0;
                    digging <= 0;
                end else if (bump_left == 0) begin
                    walk_left <= 0;
                    walk_right <= 1;
                    aaah <= 0;
                    digging <= 0;
                end
            end
            FALLING: begin
                fall_counter <= fall_counter + 1;
                if (ground == 1) begin
                    if (fall_counter > 20) begin
                        state <= SPLATTERED;
                        walk_left <= 0;
                        walk_right <= 0;
                        aaah <= 0;
                        digging <= 0;
                    end else begin
                        if (state == WALK_LEFT) begin
                            state <= WALK_LEFT;
                            walk_left <= 1;
                            walk_right <= 0;
                            aaah <= 0;
                            digging <= 0;
                        end else begin
                            state <= WALK_RIGHT;
                            walk_left <= 0;
                            walk_right <= 1;
                            aaah <= 0;
                            digging <= 0;
                        end
                        fall_counter <= 0;
                    end
                end
            end
            DIGGING: begin
                if (ground == 0) begin
                    state <= FALLING;
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 1;
                    digging <= 0;
                end
            end
            SPLATTERED: begin
                walk_left <= 0;
                walk_right <= 0;
                aaah <= 0;
                digging <= 0;
            end
        endcase
    end
end

endmodule