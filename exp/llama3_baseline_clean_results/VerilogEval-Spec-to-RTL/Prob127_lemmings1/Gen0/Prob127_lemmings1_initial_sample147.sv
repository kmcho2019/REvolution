module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

reg [0:0] current_state; // 0 - walking left, 1 - walking right
reg [0:0] next_state;

always @(*) begin
    case(current_state)
        0: begin // walking left
            if (bump_left) next_state = 1; // switch to walking right
            else next_state = 0;
        end
        1: begin // walking right
            if (bump_right) next_state = 0; // switch to walking left
            else next_state = 1;
        end
        default: next_state = 0;
    endcase

    if (bump_left && bump_right) begin // special case: bumped both sides
        if (current_state == 0) next_state = 1; // switch to walking right
        else next_state = 0; // switch to walking left
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= 0; // reset to walking left
    end else begin
        current_state <= next_state;
    end
end

assign walk_left = (current_state == 0);
assign walk_right = (current_state == 1);

endmodule