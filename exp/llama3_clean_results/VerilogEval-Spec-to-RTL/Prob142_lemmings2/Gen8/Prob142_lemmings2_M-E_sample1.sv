module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

reg [1:0] state; // 0: walking_left, 1: walking_right, 2: falling
reg direction_change;

// Combinational logic to determine the direction change
always @(*) begin
    if (bump_left && bump_right) begin
        direction_change = 1'b1;
    end else if (bump_left) begin
        direction_change = 1'b1;
    end else if (bump_right) begin
        direction_change = 1'b1;
    end else begin
        direction_change = 1'b0;
    end
end

// Sequential logic to update the state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // reset to walking left
    end else begin
        case (state)
            0: // walking left
                if (ground && direction_change) begin
                    state <= 1; // change direction to right
                end else if (~ground) begin
                    state <= 2; // start falling
                end
            1: // walking right
                if (ground && direction_change) begin
                    state <= 0; // change direction to left
                end else if (~ground) begin
                    state <= 2; // start falling
                end
            2: // falling
                if (ground) begin
                    state <= (direction_change) ? (state == 0) ? 1 : 0 : state; // resume walking in the same direction
                end
        endcase
    end
end

// Output logic
always @(*) begin
    case (state)
        0: // walking left
            begin
                walk_left = 1'b1;
                walk_right = 1'b0;
                aaah = 1'b0;
            end
        1: // walking right
            begin
                walk_left = 1'b0;
                walk_right = 1'b1;
                aaah = 1'b0;
            end
        2: // falling
            begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b1;
            end
    endcase
end

endmodule