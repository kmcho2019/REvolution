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
reg walk_left_reg;
reg walk_right_reg;
reg aaah_reg;
reg digging_reg;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00;
    end else begin
        state <= nextState;
    end
end

always @(*) begin
    case (state)
        2'b00: begin // walking left
            if (!ground) begin
                nextState = 2'b10; // falling
            end else if (dig) begin
                nextState = 2'b11; // digging
            end else if (bump_right) begin
                nextState = 2'b01; // walking right
            end else begin
                nextState = 2'b00; // walking left
            end
        end
        2'b01: begin // walking right
            if (!ground) begin
                nextState = 2'b10; // falling
            end else if (dig) begin
                nextState = 2'b11; // digging
            end else if (bump_left) begin
                nextState = 2'b00; // walking left
            end else begin
                nextState = 2'b01; // walking right
            end
        end
        2'b10: begin // falling
            if (ground) begin
                if (state == 2'b00) begin
                    nextState = 2'b00; // walking left
                end else begin
                    nextState = 2'b01; // walking right
                end
            end else begin
                nextState = 2'b10; // falling
            end
        end
        2'b11: begin // digging
            if (!ground) begin
                nextState = 2'b10; // falling
            end else begin
                nextState = 2'b11; // digging
            end
        end
        default: begin
            nextState = 2'b00; // walking left
        end
    endcase
end

always @(*) begin
    case (state)
        2'b00: begin
            walk_left_reg = 1'b1;
            walk_right_reg = 1'b0;
            aaah_reg = 1'b0;
            digging_reg = 1'b0;
        end
        2'b01: begin
            walk_left_reg = 1'b0;
            walk_right_reg = 1'b1;
            aaah_reg = 1'b0;
            digging_reg = 1'b0;
        end
        2'b10: begin
            walk_left_reg = 1'b0;
            walk_right_reg = 1'b0;
            aaah_reg = 1'b1;
            digging_reg = 1'b0;
        end
        2'b11: begin
            walk_left_reg = 1'b0;
            walk_right_reg = 1'b0;
            aaah_reg = 1'b0;
            digging_reg = 1'b1;
        end
        default: begin
            walk_left_reg = 1'b0;
            walk_right_reg = 1'b0;
            aaah_reg = 1'b0;
            digging_reg = 1'b0;
        end
    endcase
end

assign walk_left = walk_left_reg;
assign walk_right = walk_right_reg;
assign aaah = aaah_reg;
assign digging = digging_reg;

endmodule