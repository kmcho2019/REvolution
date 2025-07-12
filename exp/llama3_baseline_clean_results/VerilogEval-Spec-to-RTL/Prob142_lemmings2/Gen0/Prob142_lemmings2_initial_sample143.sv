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

// State encoding
reg [1:0] state, next_state;
parameter idle = 2'b00;
parameter walk_left_state = 2'b01;
parameter walk_right_state = 2'b10;
parameter falling_state = 2'b11;

// Output logic
always @(*) begin
    case(state)
        walk_left_state: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
        walk_right_state: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
        end
        falling_state: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
        end
        default: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
    endcase
end

// Next state logic
always @(*) begin
    if (~ground) begin
        next_state = falling_state;
    end else if (state == falling_state) begin
        next_state = walk_left_state;
    end else if (state == walk_left_state) begin
        if (bump_left) begin
            next_state = walk_right_state;
        end else begin
            next_state = walk_left_state;
        end
    end else if (state == walk_right_state) begin
        if (bump_right) begin
            next_state = walk_left_state;
        end else begin
            next_state = walk_right_state;
        end
    end else begin
        next_state = walk_left_state;
    end
end

// State register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= walk_left_state;
    end else begin
        if (bump_left && bump_right) begin
            if (state == walk_left_state) begin
                state <= walk_right_state;
            end else if (state == walk_right_state) begin
                state <= walk_left_state;
            end else begin
                state <= state;
            end
        end else begin
            state <= next_state;
        end
    end
end

endmodule