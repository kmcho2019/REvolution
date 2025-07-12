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
reg [1:0] next_state;

always @(*) begin
    case (state)
        2'b00: begin // Walking left
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
        2'b01: begin // Walking right
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
        end
        2'b10: begin // Falling
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

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        2'b00: begin // Walking left
            if (ground == 1'b0) begin
                next_state = 2'b10;
            end else if (bump_left == 1'b1) begin
                next_state = 2'b01;
            end else if (bump_right == 1'b1) begin
                next_state = 2'b01;
            end else begin
                next_state = 2'b00;
            end
        end
        2'b01: begin // Walking right
            if (ground == 1'b0) begin
                next_state = 2'b10;
            end else if (bump_left == 1'b1) begin
                next_state = 2'b00;
            end else if (bump_right == 1'b1) begin
                next_state = 2'b00;
            end else begin
                next_state = 2'b01;
            end
        end
        2'b10: begin // Falling
            if (ground == 1'b1) begin
                next_state = state[1] ? 2'b01 : 2'b00;
            end else begin
                next_state = 2'b10;
            end
        end
        default: begin
            next_state = 2'b00;
        end
    endcase
end

endmodule