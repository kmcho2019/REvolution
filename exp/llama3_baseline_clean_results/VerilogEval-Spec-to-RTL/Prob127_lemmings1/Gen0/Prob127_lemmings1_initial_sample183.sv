module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

reg [1:0] state;
localparam WALK_LEFT = 2'b00;
localparam WALK_RIGHT = 2'b01;

always @(posedge areset or posedge clk) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        case (state)
            WALK_LEFT: begin
                if (bump_left) begin
                    state <= WALK_RIGHT;
                end else if (bump_right) begin
                    state <= WALK_RIGHT;
                end else begin
                    state <= WALK_LEFT;
                end
            end
            WALK_RIGHT: begin
                if (bump_right) begin
                    state <= WALK_LEFT;
                end else if (bump_left) begin
                    state <= WALK_LEFT;
                end else begin
                    state <= WALK_RIGHT;
                end
            end
        endcase
    end
end

assign walk_left = (state == WALK_LEFT);
assign walk_right = (state == WALK_RIGHT);

endmodule