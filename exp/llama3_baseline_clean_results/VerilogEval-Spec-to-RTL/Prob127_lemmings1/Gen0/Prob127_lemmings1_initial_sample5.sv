module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

reg current_state;

localparam IDLE_LEFT = 1'b0;
localparam IDLE_RIGHT = 1'b1;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= IDLE_LEFT;
        walk_left <= 1'b1;
        walk_right <= 1'b0;
    end else begin
        if (current_state == IDLE_LEFT) begin
            if (bump_left) begin
                current_state <= IDLE_RIGHT;
                walk_left <= 1'b0;
                walk_right <= 1'b1;
            end else begin
                current_state <= IDLE_LEFT;
                walk_left <= 1'b1;
                walk_right <= 1'b0;
            end
        end else if (current_state == IDLE_RIGHT) begin
            if (bump_right) begin
                current_state <= IDLE_LEFT;
                walk_left <= 1'b1;
                walk_right <= 1'b0;
            end else begin
                current_state <= IDLE_RIGHT;
                walk_left <= 1'b0;
                walk_right <= 1'b1;
            end
        end
    end
end

endmodule