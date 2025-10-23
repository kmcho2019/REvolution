module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

reg [1:0] state; // 0: walking left, 1: walking right, 2: falling
reg [1:0] next_state;
reg prev_ground;

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 2'b00; // initial state: walking left
        prev_ground <= 1'b1;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        2'b00: begin // walking left
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            if(!ground) begin
                next_state = 2'b10; // start falling
            end else if(bump_left) begin
                next_state = 2'b01; // walk right
            end else if(bump_right) begin
                next_state = 2'b01; // walk right
            end else begin
                next_state = 2'b00; // stay walking left
            end
        end
        2'b01: begin // walking right
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            if(!ground) begin
                next_state = 2'b10; // start falling
            end else if(bump_right) begin
                next_state = 2'b00; // walk left
            end else if(bump_left) begin
                next_state = 2'b00; // walk left
            end else begin
                next_state = 2'b01; // stay walking right
            end
        end
        2'b10: begin // falling
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            if(ground) begin
                if(prev_ground == 1'b0) begin
                    if(bump_left == 1'b1 && bump_right == 1'b1) begin
                        next_state = state[0]? 2'b00 : 2'b01; // switch direction
                    end else if(bump_left == 1'b1) begin
                        next_state = 2'b01; // walk right
                    end else if(bump_right == 1'b1) begin
                        next_state = 2'b00; // walk left
                    end else begin
                        next_state = state[0]? 2'b00 : 2'b01; // resume walking
                    end
                end else begin
                    next_state = state[0]? 2'b00 : 2'b01; // resume walking
                end
            end else begin
                next_state = 2'b10; // keep falling
            end
        end
        default: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            next_state = 2'b00;
        end
    endcase
    prev_ground = ground;
end

endmodule