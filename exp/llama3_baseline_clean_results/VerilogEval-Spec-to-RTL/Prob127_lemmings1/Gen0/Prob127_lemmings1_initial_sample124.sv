module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

reg [0:0] current_state;
reg [0:0] next_state;

always @(*) begin
    case (current_state)
        1'b0: begin // walking left
            if (bump_left) begin
                next_state = 1'b1; // switch to walking right
            end else begin
                next_state = 1'b0; // stay walking left
            end
        end
        1'b1: begin // walking right
            if (bump_right) begin
                next_state = 1'b0; // switch to walking left
            end else begin
                next_state = 1'b1; // stay walking right
            end
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= 1'b0; // reset to walking left
    end else begin
        if (bump_left && bump_right) begin
            current_state <= ~current_state; // switch directions
        end else begin
            current_state <= next_state;
        end
    end
end

assign walk_left = ~current_state; // walking left when current_state is 0
assign walk_right = current_state; // walking right when current_state is 1

endmodule