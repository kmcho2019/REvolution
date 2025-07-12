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

reg [1:0] state = 2'b00; // 2'b00: walking left, 2'b01: walking right, 2'b10: falling
reg prev_walk_left = 1'b0; // 1: walking left, 0: walking right

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 2'b00;
        prev_walk_left <= 1'b1;
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
    end else begin
        case(state)
            2'b00: begin // walking left
                if(ground) begin
                    if(bump_left) begin
                        state <= 2'b01;
                        walk_left <= 1'b0;
                        walk_right <= 1'b1;
                    end else if(bump_right) begin
                        // no change
                    end else if(!bump_left && !bump_right) begin
                        // no change
                    end
                end else begin
                    state <= 2'b10;
                    prev_walk_left <= 1'b1;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                end
            end
            2'b01: begin // walking right
                if(ground) begin
                    if(bump_right) begin
                        state <= 2'b00;
                        walk_left <= 1'b1;
                        walk_right <= 1'b0;
                    end else if(bump_left) begin
                        // no change
                    end else if(!bump_left && !bump_right) begin
                        // no change
                    end
                end else begin
                    state <= 2'b10;
                    prev_walk_left <= 1'b0;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                end
            end
            2'b10: begin // falling
                if(ground) begin
                    if(prev_walk_left) begin
                        state <= 2'b00;
                        walk_left <= 1'b1;
                        walk_right <= 1'b0;
                    end else begin
                        state <= 2'b01;
                        walk_left <= 1'b0;
                        walk_right <= 1'b1;
                    end
                end else begin
                    // no change
                end
            end
        endcase
    end
end

always @(*) begin
    if(state == 2'b10) begin
        aaah = 1'b1;
    end else begin
        aaah = 1'b0;
    end
end

endmodule