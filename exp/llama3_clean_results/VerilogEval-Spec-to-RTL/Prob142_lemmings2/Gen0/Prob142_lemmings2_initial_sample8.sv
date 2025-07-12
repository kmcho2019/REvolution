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

reg [1:0] state; // 0: walking left, 1: walking right, 2: falling
reg [1:0] next_state;

// Output logic
always @(*) begin
    case (state)
        0: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
        1: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
        end
        2: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
        end
    endcase
end

// Next state logic
always @(*) begin
    case (state)
        0: begin
            if (~ground) begin
                next_state = 2;
            end else if (bump_left) begin
                next_state = 1;
            end else begin
                next_state = 0;
            end
        end
        1: begin
            if (~ground) begin
                next_state = 2;
            end else if (bump_right) begin
                next_state = 0;
            end else begin
                next_state = 1;
            end
        end
        2: begin
            if (ground) begin
                if (state == 2'b10) begin // Assuming state 2'b10 means walking left before falling
                    next_state = 0;
                end else if (state == 2'b01) begin // Assuming state 2'b01 means walking right before falling
                    next_state = 1;
                end else begin
                    next_state = 0; // Default to walking left
                end
            end else begin
                next_state = 2;
            end
        end
    endcase
end

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0;
    end else begin
        state <= next_state;
    end
end

endmodule