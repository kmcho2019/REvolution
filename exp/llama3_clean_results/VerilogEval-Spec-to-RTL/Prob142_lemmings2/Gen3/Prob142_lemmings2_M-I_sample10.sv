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

reg [1:0] state; // 2 bits to represent the state (00: walking left, 01: walking right, 10: falling left, 11: falling right)
reg [1:0] next_state;

// Combinational logic to determine the next state
always @(*) begin
    next_state = state;

    if (~ground) begin // falling
        if (state == 2'b00 || state == 2'b10) begin // walking or falling left
            next_state = 2'b10; // falling left
        end else begin // walking or falling right
            next_state = 2'b11; // falling right
        end
    end else if (ground) begin // walking
        if (bump_left && bump_right) begin // bumped on both sides
            if (state == 2'b00) begin // walking left
                next_state = 2'b01; // walking right
            end else if (state == 2'b01) begin // walking right
                next_state = 2'b00; // walking left
            end else if (state == 2'b10) begin // falling left
                next_state = 2'b01; // walking right
            end else if (state == 2'b11) begin // falling right
                next_state = 2'b00; // walking left
            end
        end else if (bump_left) begin // bumped on left
            next_state = 2'b01; // walking right
        end else if (bump_right) begin // bumped on right
            next_state = 2'b00; // walking left
        end
    end
end

// Sequential logic to update the state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // reset to walking left
    end else begin
        state <= next_state;
    end
end

// Output logic
always @(*) begin
    case(state)
        2'b00: // walking left
            begin
                walk_left = 1'b1;
                walk_right = 1'b0;
                aaah = 1'b0;
            end
        2'b01: // walking right
            begin
                walk_left = 1'b0;
                walk_right = 1'b1;
                aaah = 1'b0;
            end
        2'b10: // falling left
            begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b1;
            end
        2'b11: // falling right
            begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b1;
            end
    endcase
end

endmodule