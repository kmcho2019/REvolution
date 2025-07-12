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

reg [1:0] state, next_state;

// Define the states
localparam WALK_LEFT = 2'b00;
localparam WALK_RIGHT = 2'b01;
localparam FALLING = 2'b10;

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

// Combinational logic
always @(*) begin
    case (state)
        WALK_LEFT: begin
            if (ground == 1'b0) begin
                next_state <= FALLING;
            end else if (bump_left == 1'b1) begin
                next_state <= WALK_RIGHT;
            end else begin
                next_state <= WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            if (ground == 1'b0) begin
                next_state <= FALLING;
            end else if (bump_right == 1'b1) begin
                next_state <= WALK_LEFT;
            end else begin
                next_state <= WALK_RIGHT;
            end
        end
        FALLING: begin
            if (ground == 1'b1) begin
                if (bump_left == 1'b1 && bump_right == 1'b1) begin
                    if (next_state == WALK_LEFT) begin
                        next_state <= WALK_RIGHT;
                    end else begin
                        next_state <= WALK_LEFT;
                    end
                end else if (bump_left == 1'b1) begin
                    next_state <= WALK_RIGHT;
                end else if (bump_right == 1'b1) begin
                    next_state <= WALK_LEFT;
                end else if (next_state == WALK_LEFT) begin
                    next_state <= WALK_RIGHT;
                end else begin
                    next_state <= WALK_LEFT;
                end
            end else begin
                next_state <= FALLING;
            end
        end
    endcase
end

// Output logic
always @(*) begin
    case (state)
        WALK_LEFT: begin
            walk_left <= 1'b1;
            walk_right <= 1'b0;
            aaah <= 1'b0;
        end
        WALK_RIGHT: begin
            walk_left <= 1'b0;
            walk_right <= 1'b1;
            aaah <= 1'b0;
        end
        FALLING: begin
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b1;
        end
    endcase
end

endmodule