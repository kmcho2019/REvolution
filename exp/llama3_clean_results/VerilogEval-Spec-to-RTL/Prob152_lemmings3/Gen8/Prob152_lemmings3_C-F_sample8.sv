module TopModule (
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

reg [1:0] state;
reg [0:0] direction;
reg [1:0] next_state;
reg [0:0] next_direction;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // Initial state: walking left
        direction <= 1'b0; // Initial direction: left
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
        digging <= 1'b0;
    end else begin
        state <= next_state;
        direction <= next_direction;
        case (next_state)
            2'b00: begin // Walking
                if (next_direction == 1'b0) begin
                    walk_left <= 1'b1;
                    walk_right <= 1'b0;
                end else begin
                    walk_left <= 1'b0;
                    walk_right <= 1'b1;
                end
                aaah <= 1'b0;
                digging <= 1'b0;
            end
            2'b01: begin // Falling
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b1;
                digging <= 1'b0;
            end
            2'b10: begin // Digging
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b0;
                digging <= 1'b1;
            end
        endcase
    end
end

always_comb begin
    next_state = state;
    next_direction = direction;
    case (state)
        2'b00: begin // Walking
            if (!ground) begin
                next_state = 2'b01; // Transition to falling
            end else if (dig) begin
                next_state = 2'b10; // Transition to digging
            end else if (bump_left && !direction) begin
                next_direction = 1'b1; // Change direction to right
            end else if (bump_right && direction) begin
                next_direction = 1'b0; // Change direction to left
            end
        end
        2'b01: begin // Falling
            if (ground) begin
                next_state = 2'b00; // Transition back to walking
            end
        end
        2'b10: begin // Digging
            if (!ground) begin
                next_state = 2'b01; // Transition to falling
            end
        end
    endcase
end

endmodule