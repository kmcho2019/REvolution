module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

reg [1:0] state;
reg [1:0] next_state;

parameter IDLE_LEFT = 2'b00;
parameter IDLE_RIGHT = 2'b01;

always @(*) begin
    case(state)
        IDLE_LEFT: begin
            if(bump_left) begin
                next_state = IDLE_RIGHT;
            end else if(bump_right) begin
                next_state = IDLE_RIGHT;
            end else begin
                next_state = IDLE_LEFT;
            end
        end
        IDLE_RIGHT: begin
            if(bump_right) begin
                next_state = IDLE_LEFT;
            end else if(bump_left) begin
                next_state = IDLE_LEFT;
            end else begin
                next_state = IDLE_RIGHT;
            end
        end
        default: next_state = IDLE_LEFT;
    endcase
end

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= IDLE_LEFT;
    end else begin
        if(bump_left && bump_right) begin
            if(state == IDLE_LEFT) begin
                state <= IDLE_RIGHT;
            end else begin
                state <= IDLE_LEFT;
            end
        end else begin
            state <= next_state;
        end
    end
end

always @(*) begin
    case(state)
        IDLE_LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
        end
        IDLE_RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
        end
        default: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
        end
    endcase
end

endmodule