module TopModule (
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
reg [1:0] nextState;

localparam LEFT = 2'b00;
localparam RIGHT = 2'b01;
localparam FALLING_LEFT = 2'b10;
localparam FALLING_RIGHT = 2'b11;

assign walk_left = (state == LEFT || state == FALLING_LEFT)? 1'b1 : 1'b0;
assign walk_right = (state == RIGHT || state == FALLING_RIGHT)? 1'b1 : 1'b0;
assign aaah = (state == FALLING_LEFT || state == FALLING_RIGHT)? 1'b1 : 1'b0;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= LEFT;
    end else begin
        state <= nextState;
    end
end

always @(*) begin
    case (state)
        LEFT: begin
            if (bump_left) begin
                nextState = RIGHT;
            end else if (~ground) begin
                nextState = FALLING_LEFT;
            end else begin
                nextState = LEFT;
            end
        end
        RIGHT: begin
            if (bump_right) begin
                nextState = LEFT;
            end else if (~ground) begin
                nextState = FALLING_RIGHT;
            end else begin
                nextState = RIGHT;
            end
        end
        FALLING_LEFT: begin
            if (ground) begin
                nextState = LEFT;
            end else begin
                nextState = FALLING_LEFT;
            end
        end
        FALLING_RIGHT: begin
            if (ground) begin
                nextState = RIGHT;
            end else begin
                nextState = FALLING_RIGHT;
            end
        end
    endcase
end

endmodule