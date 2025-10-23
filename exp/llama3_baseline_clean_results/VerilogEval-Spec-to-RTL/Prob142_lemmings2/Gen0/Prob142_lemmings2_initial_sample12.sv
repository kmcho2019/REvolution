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

reg [1:0] state; // 00: walking left, 01: walking right, 10: falling left, 11: falling right

// Initialize the state to walking left
initial state = 2'b00;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Reset the state to walking left
        state <= 2'b00;
    end else begin
        case (state)
            2'b00: begin // walking left
                if (~ground) begin
                    // If the ground disappears, start falling
                    state <= 2'b10;
                end else if (bump_left) begin
                    // If the Lemming is bumped on the left, switch direction
                    state <= 2'b01;
                end else if (bump_right) begin
                    // If the Lemming is bumped on the right, do nothing
                end else begin
                    // If nothing happens, stay in the same state
                end
            end
            2'b01: begin // walking right
                if (~ground) begin
                    // If the ground disappears, start falling
                    state <= 2'b11;
                end else if (bump_left) begin
                    // If the Lemming is bumped on the left, do nothing
                end else if (bump_right) begin
                    // If the Lemming is bumped on the right, switch direction
                    state <= 2'b00;
                end else begin
                    // If nothing happens, stay in the same state
                end
            end
            2'b10: begin // falling left
                if (ground) begin
                    // If the ground reappears, stop falling
                    state <= 2'b00;
                end else begin
                    // If the ground does not reappear, keep falling
                end
            end
            2'b11: begin // falling right
                if (ground) begin
                    // If the ground reappears, stop falling
                    state <= 2'b01;
                end else begin
                    // If the ground does not reappear, keep falling
                end
            end
        endcase
    end
end

// Moore machine outputs
always @(*) begin
    case (state)
        2'b00: begin // walking left
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
        2'b01: begin // walking right
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
        end
        2'b10: begin // falling left
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
        end
        2'b11: begin // falling right
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
        end
    endcase
end

endmodule