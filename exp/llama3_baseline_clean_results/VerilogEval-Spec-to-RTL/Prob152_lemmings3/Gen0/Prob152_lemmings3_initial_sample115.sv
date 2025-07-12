module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

reg [1:0] state;
reg [1:0] nextState;

always @(*) begin
    case(state)
        2'b00: begin // walking left
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
            if (dig && ground) begin
                nextState = 2'b11; // digging
            end else if (!ground) begin
                nextState = 2'b10; // falling
            end else if (bump_right) begin
                nextState = 2'b01; // walking right
            end else begin
                nextState = 2'b00; // walking left
            end
        end
        2'b01: begin // walking right
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b0;
            if (dig && ground) begin
                nextState = 2'b11; // digging
            end else if (!ground) begin
                nextState = 2'b10; // falling
            end else if (bump_left) begin
                nextState = 2'b00; // walking left
            end else begin
                nextState = 2'b01; // walking right
            end
        end
        2'b10: begin // falling
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
            if (ground) begin
                // resume previous direction
                if (bump_left || bump_right) begin
                    // direction changes, but this is not our case
                    // since bumping while falling has no effect
                    if (state == 2'b10) begin
                        // we were falling, so we need to get the previous direction
                        // this is not directly available, so we'll need to add
                        // some additional logic to handle this case
                        reg [1:0] previousState;
                        always @(posedge clk) begin
                            if (areset) begin
                                previousState = 2'b00; // default to walking left
                            end else begin
                                previousState = state;
                            end
                        end
                        if (previousState == 2'b00) begin
                            nextState = 2'b00; // walking left
                        end else begin
                            nextState = 2'b01; // walking right
                        end
                    end
                end else begin
                    if (previousState == 2'b00) begin
                        nextState = 2'b00; // walking left
                    end else begin
                        nextState = 2'b01; // walking right
                    end
                end
            end else begin
                nextState = 2'b10; // falling
            end
        end
        2'b11: begin // digging
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
            if (!ground) begin
                nextState = 2'b10; // falling
            end else begin
                nextState = 2'b11; // digging
            end
        end
        default: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
            nextState = 2'b00; // walking left
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state = 2'b00; // walking left
    end else begin
        state = nextState;
    end
end

reg [1:0] previousState;
always @(posedge clk) begin
    if (areset) begin
        previousState = 2'b00; // default to walking left
    end else begin
        previousState = state;
    end
end

assign walk_left = (state == 2'b00) ? 1'b1 : 1'b0;
assign walk_right = (state == 2'b01) ? 1'b1 : 1'b0;
assign aaah = (state == 2'b10) ? 1'b1 : 1'b0;
assign digging = (state == 2'b11) ? 1'b1 : 1'b0;

endmodule