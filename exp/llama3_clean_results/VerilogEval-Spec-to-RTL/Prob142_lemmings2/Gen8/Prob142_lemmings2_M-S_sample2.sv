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

reg [1:0] state; // 0: walking left, 1: walking right, 2: falling
reg previous_direction;

always @(posedge clk or posedge areset) begin
    if (areset == 1'b1) begin
        state <= 2'b00; // reset to walking left
        previous_direction <= 1'b0;
    end else begin
        case (state)
            2'b00, 2'b01: begin // walking left or right
                if (ground == 1'b0) begin
                    state <= 2'b10; // transition to falling
                end else if ((bump_left == 1'b1 && state == 2'b00) || (bump_right == 1'b1 && state == 2'b01)) begin
                    // toggle walking direction when ground is present and bumped
                    previous_direction <= ~previous_direction;
                    state <= previous_direction ? 2'b01 : 2'b00;
                end
            end
            2'b10: begin // falling
                if (ground == 1'b1) begin
                    state <= previous_direction ? 2'b01 : 2'b00; // resume walking
                end
            end
        endcase
    end
end

always @(*) begin
    case (state)
        2'b00: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
        2'b01: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
        end
        2'b10: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
        end
    endcase
end

endmodule