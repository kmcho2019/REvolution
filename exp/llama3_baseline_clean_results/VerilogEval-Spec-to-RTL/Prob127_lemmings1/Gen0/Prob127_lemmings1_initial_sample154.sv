module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

reg [1:0] state; // 0: walking left, 1: walking right
reg [1:0] next_state;

always @(*) begin
    case(state)
        2'b0: begin // walking left
            if(bump_left) begin
                next_state = 2'b1; // switch to walking right
            end else begin
                next_state = 2'b0; // stay walking left
            end
        end
        2'b1: begin // walking right
            if(bump_right) begin
                next_state = 2'b0; // switch to walking left
            end else begin
                next_state = 2'b1; // stay walking right
            end
        end
        default: begin
            next_state = 2'b0; // default state
        end
    endcase

    if(bump_left && bump_right) begin
        next_state = ~state; // switch direction if bumped on both sides
    end
end

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 2'b0; // reset to walking left
    end else begin
        state <= next_state;
    end
end

assign walk_left = (state == 2'b0);
assign walk_right = (state == 2'b1);

endmodule