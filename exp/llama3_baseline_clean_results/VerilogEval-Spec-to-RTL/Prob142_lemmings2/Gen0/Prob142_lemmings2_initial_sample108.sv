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

// Output logic
always @(*) begin
    case(state)
        2'b00: begin // walking left
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
        2'b01: begin // walking right
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
        end
        2'b10: begin // falling
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
    if (~areset) begin // asynchronous reset
        next_state = 2'b00;
    end else begin
        case(state)
            2'b00: begin // walking left
                if (~ground) begin // ground disappears
                    next_state = 2'b10; // start falling
                end else if (bump_left) begin // bumped on the left
                    next_state = 2'b01; // walk right
                end else if (bump_right) begin // bumped on the right
                    next_state = 2'b01; // walk right
                end else begin // no bumps
                    next_state = 2'b00; // keep walking left
                end
            end
            2'b01: begin // walking right
                if (~ground) begin // ground disappears
                    next_state = 2'b10; // start falling
                end else if (bump_left) begin // bumped on the left
                    next_state = 2'b00; // walk left
                end else if (bump_right) begin // bumped on the right
                    next_state = 2'b00; // walk left
                end else begin // no bumps
                    next_state = 2'b01; // keep walking right
                end
            end
            2'b10: begin // falling
                if (ground) begin // ground reappears
                    if (bump_left || bump_right) begin // bumped while falling
                        next_state = state; // resume walking in the same direction
                    end else begin
                        next_state = state; // resume walking in the same direction
                    end
                end else begin // still falling
                    next_state = 2'b10; // keep falling
                end
            end
            default: begin
                next_state = 2'b00;
            end
        endcase
    end
end

// State register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00;
    end else begin
        state <= next_state;
    end
end

endmodule