module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

reg [0:0] state; // current state (0: walking left, 1: walking right)
reg [0:0] next_state; // next state

// state register
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 0; // reset to walking left
    end else begin
        state <= next_state;
    end
end

// next state logic
always @(*) begin
    case(state)
        0: begin // walking left
            if(bump_left) begin
                next_state <= 1; // switch to walking right
            end else begin
                next_state <= 0; // stay walking left
            end
        end
        1: begin // walking right
            if(bump_right) begin
                next_state <= 0; // switch to walking left
            end else begin
                next_state <= 1; // stay walking right
            end
        end
        default: next_state <= 0;
    endcase

    // override next state based on both bump_left and bump_right
    if(bump_left && bump_right) begin
        next_state <= ~state; // switch direction
    end
end

// output logic
assign walk_left = (state == 0); // walk left if state is 0
assign walk_right = (state == 1); // walk right if state is 1

endmodule