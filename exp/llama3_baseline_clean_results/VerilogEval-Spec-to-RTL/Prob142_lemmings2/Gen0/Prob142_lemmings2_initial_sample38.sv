module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output walk_left,
    output walk_right,
    output aaah
);

reg [1:0] state; // 2-bit state register
reg [1:0] nextState; // next state

always @(*) begin
    case(state)
        2'b00: // walking left
            if (bump_left || bump_right) begin
                nextState = 2'b01; // switch to walking right
            end
            else if (!ground) begin
                nextState = 2'b10; // start falling
            end
            else begin
                nextState = 2'b00; // stay walking left
            end
        2'b01: // walking right
            if (bump_left || bump_right) begin
                nextState = 2'b00; // switch to walking left
            end
            else if (!ground) begin
                nextState = 2'b11; // start falling
            end
            else begin
                nextState = 2'b01; // stay walking right
            end
        2'b10: // falling, was walking left
            if (ground) begin
                nextState = 2'b00; // resume walking left
            end
            else begin
                nextState = 2'b10; // stay falling
            end
        2'b11: // falling, was walking right
            if (ground) begin
                nextState = 2'b01; // resume walking right
            end
            else begin
                nextState = 2'b11; // stay falling
            end
        default: begin
            nextState = 2'b00; // default to walking left
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // reset to walking left
    end
    else begin
        state <= nextState;
    end
end

assign walk_left = (state == 2'b00 || state == 2'b10);
assign walk_right = (state == 2'b01 || state == 2'b11);
assign aaah = (state == 2'b10 || state == 2'b11);

endmodule