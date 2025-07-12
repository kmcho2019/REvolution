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
reg [1:0] next_state;
reg prev_walk_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // reset to walking left
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        2'b00: begin // walking left
            if (~ground) begin
                next_state = 2'b10; // falling
            end else if (bump_left) begin
                next_state = 2'b01; // walking right
            end else begin
                next_state = 2'b00; // stay walking left
            end
            prev_walk_state = 2'b00;
        end
        2'b01: begin // walking right
            if (~ground) begin
                next_state = 2'b10; // falling
            end else if (bump_right) begin
                next_state = 2'b00; // walking left
            end else begin
                next_state = 2'b01; // stay walking right
            end
            prev_walk_state = 2'b01;
        end
        2'b10: begin // falling
            if (ground) begin
                next_state = prev_walk_state; // resume walking
            end else begin
                next_state = 2'b10; // stay falling
            end
        end
        default: begin
            next_state = 2'b00; // default to walking left
        end
    endcase
end

assign walk_left = (state == 2'b00);
assign walk_right = (state == 2'b01);
assign aaah = (state == 2'b10);

endmodule