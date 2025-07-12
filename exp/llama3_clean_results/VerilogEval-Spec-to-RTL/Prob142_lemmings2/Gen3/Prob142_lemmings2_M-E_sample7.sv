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
reg direction; // 0: left, 1: right

always @(posedge clk or posedge areset) begin
    if (areset == 1'b1) begin
        state <= 2'b00; // reset to Walking Left
        direction <= 1'b0; // reset to left
    end else begin
        case(state)
            2'b00, 2'b01: begin // Walking
                if (ground == 1'b0) begin
                    state <= 2'b10; // transition to Falling
                end else if (bump_left == 1'b1 || bump_right == 1'b1) begin
                    direction <= ~direction; // switch direction
                    if (direction == 1'b0) begin
                        state <= 2'b00; // Walking Left
                    end else begin
                        state <= 2'b01; // Walking Right
                    end
                end
            end
            2'b10: begin // Falling
                if (ground == 1'b1) begin
                    if (direction == 1'b0) begin
                        state <= 2'b00; // resume Walking Left
                    end else begin
                        state <= 2'b01; // resume Walking Right
                    end
                end
            end
        endcase
    end
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