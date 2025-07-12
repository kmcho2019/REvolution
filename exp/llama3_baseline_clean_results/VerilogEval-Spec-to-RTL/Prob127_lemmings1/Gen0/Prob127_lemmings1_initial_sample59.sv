module TopModule(
    input        clk,
    input        areset,
    input        bump_left,
    input        bump_right,
    output       walk_left,
    output       walk_right
);

reg [1:0] state;
reg [1:0] next_state;

parameter IDLE_LEFT = 2'b00;
parameter IDLE_RIGHT = 2'b01;

always @(*) begin
    case (state)
        IDLE_LEFT: begin
            if (bump_left || bump_right) begin
                next_state = IDLE_RIGHT;
            end else begin
                next_state = IDLE_LEFT;
            end
        end
        IDLE_RIGHT: begin
            if (bump_left || bump_right) begin
                next_state = IDLE_LEFT;
            end else begin
                next_state = IDLE_RIGHT;
            end
        end
        default: next_state = IDLE_LEFT;
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
    end else begin
        state <= next_state;
    end
end

assign walk_left = (state == IDLE_LEFT) ? 1'b1 : 1'b0;
assign walk_right = (state == IDLE_RIGHT) ? 1'b1 : 1'b0;

endmodule