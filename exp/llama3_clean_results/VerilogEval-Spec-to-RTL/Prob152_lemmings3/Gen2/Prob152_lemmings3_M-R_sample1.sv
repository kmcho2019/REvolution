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

reg [1:0] state, next_state;

// Determine the next state
always_comb begin
    case (state)
        2'b00: begin // IDLE_LEFT
            if (!ground) begin
                next_state = 2'b10;
            end else if (dig) begin
                next_state = 2'b11;
            end else if (bump_left) begin
                next_state = 2'b01;
            end else begin
                next_state = 2'b00;
            end
        end
        2'b01: begin // IDLE_RIGHT
            if (!ground) begin
                next_state = 2'b10;
            end else if (dig) begin
                next_state = 2'b11;
            end else if (bump_right) begin
                next_state = 2'b00;
            end else begin
                next_state = 2'b01;
            end
        end
        2'b10: begin // FALLING
            if (ground) begin
                if (state == 2'b11) begin
                    next_state = 2'b00;
                end else begin
                    next_state = state == 2'b00? 2'b00 : 2'b01;
                end
            end else begin
                next_state = 2'b10;
            end
        end
        2'b11: begin // DIGGING
            if (!ground) begin
                next_state = 2'b10;
            end else begin
                next_state = 2'b11;
            end
        end
    endcase
end

// Update the state
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00;
    end else begin
        state <= next_state;
    end
end

// Determine the output signals
always_comb begin
    case (state)
        2'b00: begin // IDLE_LEFT
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
        2'b01: begin // IDLE_RIGHT
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b0;
        end
        2'b10: begin // FALLING
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
        end
        2'b11: begin // DIGGING
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
        end
    endcase
end

endmodule