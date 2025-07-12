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
localparam WALK_LEFT = 2'b01;
localparam WALK_RIGHT = 2'b10;
localparam FALLING = 2'b00;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
    end else begin
        case (state)
            WALK_LEFT: begin
                if (ground == 1'b0) begin
                    state <= FALLING;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                end else if (bump_left == 1'b1) begin
                    state <= WALK_RIGHT;
                    walk_left <= 1'b0;
                    walk_right <= 1'b1;
                    aaah <= 1'b0;
                end else if (bump_right == 1'b0 && bump_left == 1'b0) begin
                    walk_left <= 1'b1;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                end else if (bump_right == 1'b1 && bump_left == 1'b1) begin
                    state <= WALK_RIGHT;
                    walk_left <= 1'b0;
                    walk_right <= 1'b1;
                    aaah <= 1'b0;
                end else if (bump_right == 1'b1) begin
                    state <= WALK_LEFT;
                    walk_left <= 1'b1;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                end
            end
            WALK_RIGHT: begin
                if (ground == 1'b0) begin
                    state <= FALLING;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                end else if (bump_right == 1'b1) begin
                    state <= WALK_LEFT;
                    walk_left <= 1'b1;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                end else if (bump_left == 1'b0 && bump_right == 1'b0) begin
                    walk_left <= 1'b0;
                    walk_right <= 1'b1;
                    aaah <= 1'b0;
                end else if (bump_left == 1'b1 && bump_right == 1'b1) begin
                    state <= WALK_LEFT;
                    walk_left <= 1'b1;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                end else if (bump_left == 1'b1) begin
                    state <= WALK_RIGHT;
                    walk_left <= 1'b0;
                    walk_right <= 1'b1;
                    aaah <= 1'b0;
                end
            end
            FALLING: begin
                if (ground == 1'b1) begin
                    if (bump_left == 1'b0 && bump_right == 1'b0) begin
                        if (state == WALK_LEFT) begin
                            state <= WALK_LEFT;
                            walk_left <= 1'b1;
                            walk_right <= 1'b0;
                            aaah <= 1'b0;
                        end else begin
                            state <= WALK_RIGHT;
                            walk_left <= 1'b0;
                            walk_right <= 1'b1;
                            aaah <= 1'b0;
                        end
                    end else if (bump_right == 1'b1) begin
                        state <= WALK_LEFT;
                        walk_left <= 1'b1;
                        walk_right <= 1'b0;
                        aaah <= 1'b0;
                    end else if (bump_left == 1'b1) begin
                        state <= WALK_RIGHT;
                        walk_left <= 1'b0;
                        walk_right <= 1'b1;
                        aaah <= 1'b0;
                    end
                end else begin
                    state <= FALLING;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                end
            end
        endcase
    end
end

endmodule