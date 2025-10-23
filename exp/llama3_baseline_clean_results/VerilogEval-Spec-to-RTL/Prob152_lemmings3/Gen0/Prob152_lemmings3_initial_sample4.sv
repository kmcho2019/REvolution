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

// State encoding:
// 00 - Walking Left
// 01 - Walking Right
// 10 - Falling
// 11 - Digging
reg [1:0] state;
reg [1:0] nextState;

// Previous walking direction
reg prev_walk_left;
reg prev_walk_right;

always @(*) begin
    case(state)
        2'b00: begin // Walking Left
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
            if(~ground) begin
                nextState = 2'b10; // Falling
            end else if(dig) begin
                nextState = 2'b11; // Digging
            end else if(bump_left) begin
                nextState = 2'b01; // Walking Right
            end else if(bump_right) begin
                nextState = 2'b01; // Walking Right
            end else begin
                nextState = 2'b00; // Stay Walking Left
            end
        end
        2'b01: begin // Walking Right
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b0;
            if(~ground) begin
                nextState = 2'b10; // Falling
            end else if(dig) begin
                nextState = 2'b11; // Digging
            end else if(bump_left) begin
                nextState = 2'b00; // Walking Left
            end else if(bump_right) begin
                nextState = 2'b00; // Walking Left
            end else begin
                nextState = 2'b01; // Stay Walking Right
            end
        end
        2'b10: begin // Falling
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
            if(ground) begin
                if(prev_walk_left) begin
                    nextState = 2'b00; // Walking Left
                end else begin
                    nextState = 2'b01; // Walking Right
                end
            end else begin
                nextState = 2'b10; // Stay Falling
            end
        end
        2'b11: begin // Digging
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
            if(~ground) begin
                nextState = 2'b10; // Falling
            end else begin
                nextState = 2'b11; // Stay Digging
            end
        end
        default: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
            nextState = 2'b00; // Default to Walking Left
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 2'b00; // Reset to Walking Left
        prev_walk_left <= 1'b1;
        prev_walk_right <= 1'b0;
    end else begin
        state <= nextState;
        if(state == 2'b00) begin
            prev_walk_left <= 1'b1;
            prev_walk_right <= 1'b0;
        end else if(state == 2'b01) begin
            prev_walk_left <= 1'b0;
            prev_walk_right <= 1'b1;
        end else if(state == 2'b10) begin
            // No change
        end else if(state == 2'b11) begin
            // No change
        end
    end
end

endmodule