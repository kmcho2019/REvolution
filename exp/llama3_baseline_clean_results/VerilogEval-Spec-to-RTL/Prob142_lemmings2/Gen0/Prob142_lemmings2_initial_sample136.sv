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

reg [1:0] state;
reg [1:0] next_state;

always @(*) begin
    case (state)
        2'b00: begin // Walking left
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            if (ground == 1'b0) begin
                next_state = 2'b10; // Falling
            end else if (bump_left == 1'b1 && bump_right == 1'b1) begin
                next_state = 2'b01; // Switch direction
            end else if (bump_right == 1'b1) begin
                next_state = 2'b01; // Switch direction
            end else if (bump_left == 1'b1) begin
                next_state = 2'b01; // Switch direction
            end else begin
                next_state = 2'b00; // Stay walking left
            end
        end
        2'b01: begin // Walking right
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            if (ground == 1'b0) begin
                next_state = 2'b10; // Falling
            end else if (bump_left == 1'b1 && bump_right == 1'b1) begin
                next_state = 2'b00; // Switch direction
            end else if (bump_left == 1'b1) begin
                next_state = 2'b00; // Switch direction
            end else if (bump_right == 1'b1) begin
                next_state = 2'b00; // Switch direction
            end else begin
                next_state = 2'b01; // Stay walking right
            end
        end
        2'b10: begin // Falling
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            if (ground == 1'b1) begin
                if (next_state == 2'b00) begin
                    next_state = 2'b00; // Resume walking left
                end else begin
                    next_state = 2'b01; // Resume walking right
                end
            end else begin
                next_state = 2'b10; // Stay falling
            end
        end
        default: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            next_state = 2'b00; // Reset to walking left
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // Reset to walking left
    end else begin
        state <= next_state;
    end
end

endmodule