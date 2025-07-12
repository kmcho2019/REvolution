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
reg walk_direction;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00;
        walk_direction <= 1'b0;
    end else begin
        state <= nextState;
    end
end

always @(*) begin
    case (state)
        2'b00: begin // walking left
            if (!ground) begin
                nextState = 2'b10;
            end else if (dig && ground) begin
                nextState = 2'b11;
            end else if (bump_right) begin
                nextState = 2'b01;
            end else begin
                nextState = 2'b00;
            end
        end
        2'b01: begin // walking right
            if (!ground) begin
                nextState = 2'b10;
            end else if (dig && ground) begin
                nextState = 2'b11;
            end else if (bump_left) begin
                nextState = 2'b00;
            end else begin
                nextState = 2'b01;
            end
        end
        2'b10: begin // falling
            if (ground) begin
                if (walk_direction) begin
                    nextState = 2'b01;
                end else begin
                    nextState = 2'b00;
                end
            end else begin
                nextState = 2'b10;
            end
        end
        2'b11: begin // digging
            if (!ground) begin
                nextState = 2'b10;
            end else begin
                nextState = 2'b11;
            end
        end
    endcase
end

always @(posedge clk) begin
    if (state == 2'b00 || state == 2'b01) begin
        walk_direction <= state[0];
    end
end

assign walk_left = (state == 2'b00) || (state == 2'b10 &&!walk_direction);
assign walk_right = (state == 2'b01) || (state == 2'b10 && walk_direction);
assign aaah = state == 2'b10;
assign digging = state == 2'b11;

endmodule