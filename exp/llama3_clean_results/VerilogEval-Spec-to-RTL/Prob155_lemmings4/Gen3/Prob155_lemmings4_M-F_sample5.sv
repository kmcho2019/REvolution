module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

reg [2:0] state; // 3'd0: walking left, 3'd1: walking right, 3'd2: falling, 3'd3: digging, 3'd4: splattered
reg [4:0] fall_counter;
reg prev_ground;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 3'd0; // Reset to walking left
        fall_counter <= 5'd0;
        prev_ground <= 1'b1;
    end else begin
        case (state)
            3'd0: begin // Walking left
                if (!ground) begin
                    state <= 3'd2; // Fall
                    fall_counter <= 5'd1;
                end else if (dig) begin
                    state <= 3'd3; // Dig
                end else if (bump_left) begin
                    state <= 3'd1; // Walk right
                end
            end
            3'd1: begin // Walking right
                if (!ground) begin
                    state <= 3'd2; // Fall
                    fall_counter <= 5'd1;
                end else if (dig) begin
                    state <= 3'd3; // Dig
                end else if (bump_right) begin
                    state <= 3'd0; // Walk left
                end
            end
            3'd2: begin // Falling
                fall_counter <= fall_counter + 1;
                if (ground) begin
                    if (fall_counter > 5'd20) begin
                        state <= 3'd4; // Splatter
                    end else begin
                        if (prev_ground == 1'b0) begin // Transitioning from falling to walking
                            if (prev_state == 3'd0) begin
                                state <= 3'd0; // Walk left
                            end else begin
                                state <= 3'd1; // Walk right
                            end
                        end
                    end
                end
            end
            3'd3: begin // Digging
                if (!ground) begin
                    state <= 3'd2; // Fall
                    fall_counter <= 5'd1;
                end
            end
            3'd4: begin // Splattered
                // No transitions from splattered state
            end
        endcase
        prev_ground <= ground;
    end
end

assign walk_left = (state == 3'd0);
assign walk_right = (state == 3'd1);
assign aaah = (state == 3'd2);
assign digging = (state == 3'd3);

endmodule