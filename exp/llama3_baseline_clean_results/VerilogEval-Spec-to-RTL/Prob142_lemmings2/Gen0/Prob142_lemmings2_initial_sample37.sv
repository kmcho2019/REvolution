module TopModule (
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
localparam left = 2'b00;
localparam right = 2'b01;
localparam falling_left = 2'b10;
localparam falling_right = 2'b11;

always @(posedge areset or posedge clk) begin
    if (posedge areset) begin
        state <= left;
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
    end else if (posedge clk) begin
        case (state)
            left: begin
                if (ground == 1'b0) begin
                    state <= falling_left;
                end else if (bump_left == 1'b1 || bump_right == 1'b1) begin
                    state <= right;
                end
            end
            right: begin
                if (ground == 1'b0) begin
                    state <= falling_right;
                end else if (bump_left == 1'b1 || bump_right == 1'b1) begin
                    state <= left;
                end
            end
            falling_left: begin
                if (ground == 1'b1) begin
                    state <= left;
                end
            end
            falling_right: begin
                if (ground == 1'b1) begin
                    state <= right;
                end
            end
        endcase
    end
end

always @(*) begin
    case (state)
        left: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
        right: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
        end
        falling_left: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
        end
        falling_right: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
        end
    endcase
end

endmodule