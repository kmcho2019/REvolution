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

// Define states
enum logic [1:0] {
    WALKING,
    FALLING,
    DIGGING,
    SPLATTERED
} state, next_state;

reg [4:0] fall_counter;
reg walk_direction;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING;
        walk_direction <= 1'b0;
        fall_counter <= 5'b0;
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
        digging <= 1'b0;
    end else begin
        case (state)
            WALKING: begin
                if (~ground) begin
                    state <= FALLING;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                    digging <= 1'b0;
                end else if (dig && ground) begin
                    state <= DIGGING;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                    digging <= 1'b1;
                end else if (bump_left || bump_right) begin
                    walk_direction <= ~walk_direction;
                    walk_left <= ~walk_direction;
                    walk_right <= walk_direction;
                end
            end
            FALLING: begin
                if (ground) begin
                    if (fall_counter > 5'd20) begin
                        state <= SPLATTERED;
                        walk_left <= 1'b0;
                        walk_right <= 1'b0;
                        aaah <= 1'b0;
                        digging <= 1'b0;
                    end else begin
                        state <= WALKING;
                        walk_left <= ~walk_direction;
                        walk_right <= walk_direction;
                        aaah <= 1'b0;
                        digging <= 1'b0;
                    end
                end else begin
                    fall_counter <= fall_counter + 1'b1;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                    digging <= 1'b0;
                end
            end
            DIGGING: begin
                if (~ground) begin
                    state <= FALLING;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                    digging <= 1'b0;
                end else begin
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