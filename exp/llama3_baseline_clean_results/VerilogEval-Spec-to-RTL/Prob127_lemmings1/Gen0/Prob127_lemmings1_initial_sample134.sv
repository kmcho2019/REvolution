module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

reg [1:0] state; // 0: walk_left, 1: walk_right
reg [1:0] next_state;

localparam IDLE = 2'b00; // walk_left
localparam WALK_RIGHT = 2'b01; // walk_right

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        IDLE: begin
            if(bump_left) begin
                next_state <= WALK_RIGHT;
            end else if(bump_right) begin
                next_state <= WALK_RIGHT;
            end else begin
                next_state <= IDLE;
            end
        end
        WALK_RIGHT: begin
            if(bump_right) begin
                next_state <= IDLE;
            end else if(bump_left) begin
                next_state <= IDLE;
            end else begin
                next_state <= WALK_RIGHT;
            end
        end
        default: next_state <= IDLE;
    endcase
end

assign walk_left = (state == IDLE);
assign walk_right = (state == WALK_RIGHT);

endmodule