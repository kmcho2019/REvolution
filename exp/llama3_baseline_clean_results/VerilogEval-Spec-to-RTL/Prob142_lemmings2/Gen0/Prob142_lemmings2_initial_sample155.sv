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

// State encoding: 2'b00 - walking left, 2'b01 - walking right, 2'b10 - falling
reg [1:0] state, next_state;
reg [1:0] direction_before_fall;

always @(*) begin
    // Default next state is the current state
    next_state = state;

    case (state)
        2'b00: begin // walking left
            if (bump_left) begin
                next_state = 2'b01;
            end
            if (!ground) begin
                next_state = 2'b10;
                direction_before_fall = 2'b00;
            end
        end
        2'b01: begin // walking right
            if (bump_right) begin
                next_state = 2'b00;
            end
            if (!ground) begin
                next_state = 2'b10;
                direction_before_fall = 2'b01;
            end
        end
        2'b10: begin // falling
            if (ground) begin
                next_state = direction_before_fall;
            end
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        2'b00: begin // walking left
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
        2'b01: begin // walking right
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
        end
        2'b10: begin // falling
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
        end
    endcase
end

endmodule