module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

reg [1:0] state;
reg [1:0] nextState;

always @(posedge clk or posedge areset) begin
    if (areset == 1'b1) begin
        state <= 2'b00; // reset to Walking Left
    end else begin
        state <= nextState;
    end
end

always @(*) begin
    case(state)
        2'b00: begin // Walking Left
            if (ground == 1'b0) begin
                nextState = 2'b10; // transition to Falling
            end else if (bump_left == 1'b1) begin
                nextState = 2'b01; // switch to Walking Right
            end else if (bump_right == 1'b1) begin
                nextState = 2'b01; // switch to Walking Right
            end else begin
                nextState = 2'b00; // remain Walking Left
            end
        end
        2'b01: begin // Walking Right
            if (ground == 1'b0) begin
                nextState = 2'b10; // transition to Falling
            end else if (bump_left == 1'b1) begin
                nextState = 2'b00; // switch to Walking Left
            end else if (bump_right == 1'b1) begin
                nextState = 2'b00; // switch to Walking Left
            end else begin
                nextState = 2'b01; // remain Walking Right
            end
        end
        2'b10: begin // Falling
            if (ground == 1'b1) begin
                if (bump_left == 1'b1 && bump_right == 1'b1) begin
                    nextState = state; // remain Falling
                end else if (bump_left == 1'b1) begin
                    nextState = 2'b01; // switch to Walking Right
                end else if (bump_right == 1'b1) begin
                    nextState = 2'b00; // switch to Walking Left
                end else if (state == 2'b00) begin
                    nextState = 2'b00; // resume Walking Left
                end else if (state == 2'b01) begin
                    nextState = 2'b01; // resume Walking Right
                end else begin
                    nextState = 2'b00; // default to Walking Left
                end
            end else begin
                nextState = 2'b10; // remain Falling
            end
        end
    endcase
end

always @(*) begin
    case(state)
        2'b00: begin // Walking Left
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
        2'b01: begin // Walking Right
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
        end
        2'b10: begin // Falling
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
        end
    endcase
end

endmodule