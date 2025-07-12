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

reg [1:0] state; // 2 bits to represent the state (00: walking left, 01: walking right, 10: falling)

// Combinational logic to determine the next state
always @(*) begin
    case(state)
        2'b00: // walking left
            begin
                if (~ground) begin
                    state = 2'b10; // falling
                end else if (bump_left) begin
                    state = 2'b01; // walking right
                end else if (bump_right) begin
                    // do nothing, keep walking left
                end
            end
        2'b01: // walking right
            begin
                if (~ground) begin
                    state = 2'b10; // falling
                end else if (bump_right) begin
                    state = 2'b00; // walking left
                end else if (bump_left) begin
                    // do nothing, keep walking right
                end
            end
        2'b10: // falling
            begin
                if (ground) begin
                    // stay in the same direction as before the fall
                    if (bump_left) begin
                        state = 2'b01; // walking right
                    end else if (bump_right) begin
                        state = 2'b00; // walking left
                    end else begin
                        if (walk_left) begin
                            state = 2'b00; // walking left
                        end else begin
                            state = 2'b01; // walking right
                        end
                    end
                end
            end
    endcase
end

// Sequential logic to update the state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // reset to walking left
        walk_left <= 1'b1;
        walk_right <= 1'b0;
    end else begin
        if (state == 2'b10) begin
            walk_left <= 1'b0;
            walk_right <= 1'b0;
        end else if (state == 2'b00) begin
            walk_left <= 1'b1;
            walk_right <= 1'b0;
        end else if (state == 2'b01) begin
            walk_left <= 1'b0;
            walk_right <= 1'b1;
        end
    end
end

// Output logic
assign aaah = (state == 2'b10)? 1'b1 : 1'b0;

endmodule