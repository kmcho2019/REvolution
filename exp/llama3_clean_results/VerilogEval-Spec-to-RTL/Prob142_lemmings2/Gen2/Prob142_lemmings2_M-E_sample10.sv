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

// 1-hot encoding for direction controller
reg [1:0] direction;
reg [1:0] next_direction;

// 1-hot encoding for state controller
reg [1:0] state;
reg [1:0] next_state;

// Combinational logic for direction controller
always @(*) begin
    next_direction = direction;

    case(direction)
        2'b01: // walking left
            begin
                if (bump_left) begin
                    next_direction = 2'b10; // walking right
                end
            end
        2'b10: // walking right
            begin
                if (bump_right) begin
                    next_direction = 2'b01; // walking left
                end
            end
    endcase
end

// Combinational logic for state controller
always @(*) begin
    next_state = state;

    case(state)
        2'b01: // walking
            begin
                if (~ground) begin
                    next_state = 2'b10; // falling
                end
            end
        2'b10: // falling
            begin
                if (ground) begin
                    next_state = 2'b01; // walking
                end
            end
    endcase
end

// Sequential logic to update direction and state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        direction <= 2'b01; // reset to walking left
        state <= 2'b01; // reset to walking
    end else begin
        direction <= next_direction;
        state <= next_state;
    end
end

// Output logic
always @(*) begin
    walk_left = (direction == 2'b01) && (state == 2'b01);
    walk_right = (direction == 2'b10) && (state == 2'b01);
    aaah = (state == 2'b10);
end

endmodule