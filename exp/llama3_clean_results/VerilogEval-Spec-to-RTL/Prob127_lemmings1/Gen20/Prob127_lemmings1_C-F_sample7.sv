module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output logic walk_left,
    output logic walk_right
);

reg state;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b1; // Initialize state to walking left
    end else begin
        case (1'b1)
            1'b1: state <= (bump_left && !bump_right) ? 1'b0 :
                      (bump_right && !bump_left) ? 1'b1 :
                      (bump_left && bump_right) ? ~state : state;
        endcase
    end
end

always_comb begin
    case (state)
        1'b1: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
        end
        1'b0: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
        end
        default: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
        end
    endcase
end

endmodule