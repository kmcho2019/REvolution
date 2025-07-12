module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

reg [1:0] state; // 0: walking_left, 1: walking_right, 2: falling, 3: digging
reg direction; // 0: left, 1: right

initial state = 0;
initial direction = 0;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state = 0;
        direction = 0;
    end else begin
        case (state)
            0: begin // walking_left
                if (!ground) begin
                    state = 2; // falling
                end else if (dig && !bump_left && !bump_right) begin
                    state = 3; // digging
                    direction = 0; // keep direction
                end else if (bump_left || (bump_left && bump_right)) begin
                    state = 0; // walking_left
                    direction = 1; // switch direction
                end else if (bump_right) begin
                    state = 1; // walking_right
                    direction = 1; // switch direction
                end
            end
            1: begin // walking_right
                if (!ground) begin
                    state = 2; // falling
                end else if (dig && !bump_right && !bump_left) begin
                    state = 3; // digging
                    direction = 1; // keep direction
                end else if (bump_right || (bump_left && bump_right)) begin
                    state = 1; // walking_right
                    direction = 0; // switch direction
                end else if (bump_left) begin
                    state = 0; // walking_left
                    direction = 0; // switch direction
                end
            end
            2: begin // falling
                if (ground) begin
                    if (direction == 0) begin
                        state = 0; // walking_left
                    end else begin
                        state = 1; // walking_right
                    end
                end
            end
            3: begin // digging
                if (!ground) begin
                    state = 2; // falling
                end
            end
        endcase
    end
end

assign walk_left = (state == 0 || (state == 3 && direction == 0));
assign walk_right = (state == 1 || (state == 3 && direction == 1));
assign aaah = (state == 2);
assign digging = (state == 3);

endmodule