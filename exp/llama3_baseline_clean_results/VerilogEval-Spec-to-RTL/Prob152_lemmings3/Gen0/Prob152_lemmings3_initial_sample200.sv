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

reg [1:0] state;
reg [1:0] nextState;

always @(*) begin
    case(state)
        2'b00: begin // idle_left
            if (!ground) begin
                nextState = 2'b11; // falling
            end else if (dig) begin
                nextState = 2'b10; // digging
            end else if (bump_right) begin
                nextState = 2'b01; // idle_right
            end else begin
                nextState = 2'b00; // idle_left
            end
        end
        2'b01: begin // idle_right
            if (!ground) begin
                nextState = 2'b11; // falling
            end else if (dig) begin
                nextState = 2'b10; // digging
            end else if (bump_left) begin
                nextState = 2'b00; // idle_left
            end else begin
                nextState = 2'b01; // idle_right
            end
        end
        2'b10: begin // digging
            if (!ground) begin
                nextState = 2'b11; // falling
            end else begin
                nextState = 2'b10; // digging
            end
        end
        2'b11: begin // falling
            if (ground) begin
                if (state == 2'b11 && (bump_left || bump_right)) begin
                    nextState = state; // ignore bump
                end else if (state == 2'b11 && dig) begin
                    nextState = state; // ignore dig
                end else if (state == 2'b00) begin
                    nextState = 2'b00; // idle_left
                end else if (state == 2'b01) begin
                    nextState = 2'b01; // idle_right
                end else begin
                    nextState = state; // ignore other conditions
                end
            end else begin
                nextState = 2'b11; // falling
            end
        end
        default: begin
            nextState = 2'b00; // idle_left
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // idle_left
    end else begin
        state <= nextState;
    end
end

always @(*) begin
    case(state)
        2'b00: begin // idle_left
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
        2'b01: begin // idle_right
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b0;
        end
        2'b10: begin // digging
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
        end
        2'b11: begin // falling
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
        end
        default: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
    endcase
end

endmodule