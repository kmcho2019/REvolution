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

always @(posedge clk or posedge areset) begin
    if (areset == 1'b1) begin
        current_state <= 2'b00; // reset to Walking Left
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
    end else begin
        case(current_state)
            2'b00: begin // Walking Left
                walk_left <= 1'b1;
                walk_right <= 1'b0;
                aaah <= 1'b0;
                if (ground == 1'b0) begin
                    current_state <= 2'b10; // Falling Left
                end else if (bump_left == 1'b1) begin
                    current_state <= 2'b01; // Walking Right
                end else if (bump_right == 1'b1) begin
                    current_state <= 2'b01; // Walking Right
                end else begin
                    current_state <= 2'b00; // Still Walking Left
                end
            end
            2'b01: begin // Walking Right
                walk_left <= 1'b0;
                walk_right <= 1'b1;
                aaah <= 1'b0;
                if (ground == 1'b0) begin
                    current_state <= 2'b11; // Falling Right
                end else if (bump_right == 1'b1) begin
                    current_state <= 2'b00; // Walking Left
                end else if (bump_left == 1'b1) begin
                    current_state <= 2'b00; // Walking Left
                end else begin
                    current_state <= 2'b01; // Still Walking Right
                end
            end
            2'b10: begin // Falling Left
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b1;
                if (ground == 1'b1) begin
                    current_state <= 2'b00; // Resume walking left
                end else begin
                    current_state <= 2'b10; // Still Falling Left
                end
            end
            2'b11: begin // Falling Right
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b1;
                if (ground == 1'b1) begin
                    current_state <= 2'b01; // Resume walking right
                end else begin
                    current_state <= 2'b11; // Still Falling Right
                end
            end
            default: begin // invalid state, should not happen
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b0;
                current_state <= 2'b00; // default to Walking Left
            end
        endcase
    end
end

endmodule