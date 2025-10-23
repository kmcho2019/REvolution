module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

reg [1:0] state; // 0: walking left, 1: walking right, 2: falling, 3: digging
reg prev_dig;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // walking left
        prev_dig <= 0;
    end else begin
        case (state)
            0: begin // walking left
                if (bump_left) begin
                    state <= 1; // walking right
                end else if (!ground) begin
                    state <= 2; // falling
                end else if (dig) begin
                    state <= 3; // digging
                end
            end
            1: begin // walking right
                if (bump_right) begin
                    state <= 0; // walking left
                end else if (!ground) begin
                    state <= 2; // falling
                end else if (dig) begin
                    state <= 3; // digging
                end
            end
            2: begin // falling
                if (ground) begin
                    state <= (prev_dig) ? 0 : 0; // resume walking left
                    prev_dig <= 0;
                end
            end
            3: begin // digging
                if (!ground) begin
                    state <= 2; // falling
                end
            end
        endcase
        if (dig && (state == 0 || state == 1)) begin
            prev_dig <= 1;
        end
    end
end

always_comb begin
    walk_left = (state == 0) ? 1'b1 : 1'b0;
    walk_right = (state == 1) ? 1'b1 : 1'b0;
    aaah = (state == 2) ? 1'b1 : 1'b0;
    digging = (state == 3) ? 1'b1 : 1'b0;
end

endmodule