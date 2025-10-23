module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

reg [1:0] state;
parameter WALK_LEFT = 2'b00;
parameter WALK_RIGHT = 2'b01;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        case (state)
            WALK_LEFT: begin
                if (bump_left) begin
                    state <= WALK_RIGHT;
                end
            end
            WALK_RIGHT: begin
                if (bump_right) begin
                    state <= WALK_LEFT;
                end
            end
            default: state <= WALK_LEFT;
        endcase

        // handle case where bump_left and bump_right are both 1
        if (bump_left && bump_right) begin
            case (state)
                WALK_LEFT: state <= WALK_RIGHT;
                WALK_RIGHT: state <= WALK_LEFT;
            endcase
        end
    end
end

always @(*) begin
    case (state)
        WALK_LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
        end
        WALK_RIGHT: begin
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