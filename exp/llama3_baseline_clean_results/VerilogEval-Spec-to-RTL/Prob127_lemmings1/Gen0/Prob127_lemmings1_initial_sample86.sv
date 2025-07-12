module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

reg [0:0] state;
reg [0:0] next_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // Reset to walking left
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        0: begin // Walking left
            walk_left = 1;
            walk_right = 0;
            if (bump_left) begin
                next_state = 1; // Switch to walking right
            end else begin
                next_state = 0; // Stay walking left
            end
        end
        1: begin // Walking right
            walk_left = 0;
            walk_right = 1;
            if (bump_right) begin
                next_state = 0; // Switch to walking left
            end else begin
                next_state = 1; // Stay walking right
            end
        end
        default: begin
            walk_left = 0;
            walk_right = 0;
            next_state = 0;
        end
    endcase
    
    // If both bump_left and bump_right are high, switch directions
    if (bump_left && bump_right) begin
        next_state = ~state;
    end
end

endmodule