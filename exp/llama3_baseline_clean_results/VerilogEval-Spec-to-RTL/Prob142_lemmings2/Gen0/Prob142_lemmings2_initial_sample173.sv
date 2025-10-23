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
reg [1:0] prevState;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // Initialize state to WALK_LEFT
        prevState <= 2'b00; // Initialize previous state to WALK_LEFT
    end else begin
        case (state)
            2'b00: begin // WALK_LEFT
                if (!ground) begin
                    state <= 2'b10; // Start falling
                    prevState <= 2'b00; // Save previous state
                end else if (bump_left) begin
                    state <= 2'b01; // Change direction to WALK_RIGHT
                end else if (bump_right) begin
                    // Do nothing, already walking left
                end
            end
            2'b01: begin // WALK_RIGHT
                if (!ground) begin
                    state <= 2'b10; // Start falling
                    prevState <= 2'b01; // Save previous state
                end else if (bump_left) begin
                    // Do nothing, already walking right
                end else if (bump_right) begin
                    state <= 2'b00; // Change direction to WALK_LEFT
                end
            end
            2'b10: begin // FALLING
                if (ground) begin
                    state <= prevState; // Resume walking in previous direction
                end
            end
        endcase
    end
end

always @(*) begin
    case (state)
        2'b00: begin // WALK_LEFT
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
        2'b01: begin // WALK_RIGHT
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
        end
        2'b10: begin // FALLING
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
        end
    endcase
end

endmodule