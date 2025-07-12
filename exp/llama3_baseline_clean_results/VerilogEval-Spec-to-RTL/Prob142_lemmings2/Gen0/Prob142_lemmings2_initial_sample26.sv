module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output walk_left,
    output walk_right,
    output aaah
);

reg [1:0] state;
reg [1:0] nextState;

always @(*) begin
    case (state)
        2'b00: begin // walking left
            if (~ground) begin
                nextState = 2'b10; // falling
            end else if (bump_left) begin
                nextState = 2'b01; // walk right
            end else begin
                nextState = 2'b00; // stay walking left
            end
        end
        2'b01: begin // walking right
            if (~ground) begin
                nextState = 2'b10; // falling
            end else if (bump_right) begin
                nextState = 2'b00; // walk left
            end else begin
                nextState = 2'b01; // stay walking right
            end
        end
        2'b10: begin // falling
            if (ground) begin
                if (bump_left && bump_right) begin
                    if (state == 2'b00) begin
                        nextState = 2'b01; // walk right
                    end else begin
                        nextState = 2'b00; // walk left
                    end
                end else if (bump_left) begin
                    nextState = 2'b01; // walk right
                end else if (bump_right) begin
                    nextState = 2'b00; // walk left
                end else begin
                    if (state == 2'b00) begin
                        nextState = 2'b00; // walk left
                    end else begin
                        nextState = 2'b01; // walk right
                    end
                end
            end else begin
                nextState = 2'b10; // stay falling
            end
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // reset to walking left
    end else begin
        state <= nextState;
    end
end

assign walk_left = (state == 2'b00);
assign walk_right = (state == 2'b01);
assign aaah = (state == 2'b10);

endmodule