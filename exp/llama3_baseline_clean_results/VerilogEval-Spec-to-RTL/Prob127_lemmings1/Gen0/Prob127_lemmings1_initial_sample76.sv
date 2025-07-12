module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

// Define the states
parameter STATE_LEFT = 1'b0;
parameter STATE_RIGHT = 1'b1;

// Internal state signal
reg [0:0] state;

// Next state logic
always @(*) begin
    case (state)
        STATE_LEFT: begin
            if (bump_left) begin
                walk_left <= 1'b0;
                walk_right <= 1'b1;
            end else begin
                walk_left <= 1'b1;
                walk_right <= 1'b0;
            end
        end
        STATE_RIGHT: begin
            if (bump_right) begin
                walk_left <= 1'b1;
                walk_right <= 1'b0;
            end else begin
                walk_left <= 1'b0;
                walk_right <= 1'b1;
            end
        end
        default: begin
            walk_left <= 1'b0;
            walk_right <= 1'b0;
        end
    endcase

    if (bump_left && bump_right) begin
        if (state == STATE_LEFT) begin
            walk_left <= 1'b0;
            walk_right <= 1'b1;
        end else begin
            walk_left <= 1'b1;
            walk_right <= 1'b0;
        end
    end
end

// State update logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= STATE_LEFT;
    end else begin
        if (bump_left && state == STATE_LEFT) begin
            state <= STATE_RIGHT;
        end else if (bump_right && state == STATE_RIGHT) begin
            state <= STATE_LEFT;
        end else if (bump_left && state == STATE_RIGHT) begin
            state <= STATE_LEFT;
        end else if (bump_right && state == STATE_LEFT) begin
            state <= STATE_RIGHT;
        end
    end
end

assign walk_left = (state == STATE_LEFT)? 1'b1 : 1'b0;
assign walk_right = (state == STATE_RIGHT)? 1'b1 : 1'b0;

endmodule