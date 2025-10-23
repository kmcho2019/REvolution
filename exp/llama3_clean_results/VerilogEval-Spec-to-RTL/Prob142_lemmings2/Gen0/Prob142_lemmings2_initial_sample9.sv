module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

reg [1:0] state, next_state;

localparam walking_left = 2'b00;
localparam walking_right = 2'b01;
localparam falling = 2'b10;

always @(*) begin
    case(state)
        walking_left: begin
            if (bump_left || bump_right) begin
                next_state = walking_right;
            end else if (!ground) begin
                next_state = falling;
            end else begin
                next_state = walking_left;
            end
        end
        walking_right: begin
            if (bump_left || bump_right) begin
                next_state = walking_left;
            end else if (!ground) begin
                next_state = falling;
            end else begin
                next_state = walking_right;
            end
        end
        falling: begin
            if (ground) begin
                if (state == falling) begin // falling due to last ground loss
                    if (bump_left || bump_right) begin
                        next_state = walking_right;
                    end else begin
                        next_state = walking_left;
                    end
                end else begin // falling and changing direction in same cycle as ground appears or before last ground loss
                    next_state = walking_left; // assume initial direction walking left
                end
            end else begin
                next_state = falling;
            end
        end
        default: next_state = walking_left;
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= walking_left;
    end else begin
        state <= next_state;
    end
end

always @(state) begin
    case(state)
        walking_left: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
        walking_right: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
        end
        falling: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
        end
        default: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
    endcase
end

endmodule