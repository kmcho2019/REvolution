module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

reg [1:0] current_state;
reg [1:0] next_state;

always @(*) begin
    case (current_state)
        2'b00: begin // walking left
            if (ground == 0) begin
                next_state = 2'b10; // falling
            end else if (bump_left == 1) begin
                next_state = 2'b01; // walking right
            end else begin
                next_state = 2'b00; // walking left
            end
        end
        2'b01: begin // walking right
            if (ground == 0) begin
                next_state = 2'b10; // falling
            end else if (bump_right == 1) begin
                next_state = 2'b00; // walking left
            end else begin
                next_state = 2'b01; // walking right
            end
        end
        2'b10: begin // falling
            if (ground == 1) begin
                if (bump_left == 1'b1 && bump_right == 1'b1) begin
                    next_state = 2'b00; // walking left
                end else if (bump_left == 1'b1) begin
                    next_state = 2'b01; // walking right
                end else if (bump_right == 1'b1) begin
                    next_state = 2'b00; // walking left
                end else begin
                    // Save the direction before the fall
                    if (current_state == 2'b00) begin
                        next_state = 2'b00; // walking left
                    end else begin
                        next_state = 2'b01; // walking right
                    end
                end
            end else begin
                next_state = 2'b10; // falling
            end
        end
        default: next_state = 2'b00;
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset == 1'b1) begin
        current_state <= 2'b00;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case (current_state)
        2'b00: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
        2'b01: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
        end
        2'b10: begin
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