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

// State variables
reg [1:0] state;
reg [0:0] original_direction;

// Output logic
always @(*) begin
    case (state)
        2'b00: begin // walking left
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
        2'b01: begin // walking right
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b0;
        end
        2'b10: begin // falling
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
        end
        2'b11: begin // digging
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
        end
    endcase
end

// State transition logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // Reset to walking left
        original_direction <= 1'b0; // Reset original direction to left
    end else begin
        case (state)
            2'b00: begin // walking left
                if (!ground) begin
                    state <= 2'b10; // Start falling
                    original_direction <= 1'b0; // Remember original direction
                end else if (dig) begin
                    state <= 2'b11; // Start digging
                    original_direction <= 1'b0; // Remember original direction
                end else if (bump_left) begin
                    state <= 2'b01; // Switch to walking right
                end
            end
            2'b01: begin // walking right
                if (!ground) begin
                    state <= 2'b10; // Start falling
                    original_direction <= 1'b1; // Remember original direction
                end else if (dig) begin
                    state <= 2'b11; // Start digging
                    original_direction <= 1'b1; // Remember original direction
                end else if (bump_right) begin
                    state <= 2'b00; // Switch to walking left
                end
            end
            2'b10: begin // falling
                if (ground) begin
                    if (original_direction) begin
                        state <= 2'b01; // Resume walking right
                    end else begin
                        state <= 2'b00; // Resume walking left
                    end
                end
            end
            2'b11: begin // digging
                if (!ground) begin
                    state <= 2'b10; // Start falling
                end
            end
        endcase
    end
end

endmodule