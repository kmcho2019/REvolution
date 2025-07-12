module TopModule(
    input            clk,
    input            areset,
    input            bump_left,
    input            bump_right,
    output reg       walk_left,
    output reg       walk_right
);

reg [1:0] state; // 0: walking left, 1: walking right

localparam IDLE_LEFT = 1'b0;
localparam IDLE_RIGHT = 1'b1;

always @(posedge clk or posedge areset) begin
    if(areset) begin
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        state <= IDLE_LEFT;
    end else begin
        case(state)
            IDLE_LEFT: begin
                if(bump_left) begin
                    walk_left <= 1'b0;
                    walk_right <= 1'b1;
                    state <= IDLE_RIGHT;
                end else if(bump_right) begin
                    walk_left <= 1'b1;
                    walk_right <= 1'b0;
                    state <= IDLE_LEFT;
                end else begin
                    walk_left <= 1'b1;
                    walk_right <= 1'b0;
                    state <= IDLE_LEFT;
                end
            end
            IDLE_RIGHT: begin
                if(bump_left) begin
                    walk_left <= 1'b1;
                    walk_right <= 1'b0;
                    state <= IDLE_LEFT;
                end else if(bump_right) begin
                    walk_left <= 1'b0;
                    walk_right <= 1'b1;
                    state <= IDLE_RIGHT;
                end else begin
                    walk_left <= 1'b0;
                    walk_right <= 1'b1;
                    state <= IDLE_RIGHT;
                end
            end
            default: begin
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                state <= IDLE_LEFT;
            end
        endcase
    end
end

endmodule