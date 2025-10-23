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

// Top-level state machine
reg [1:0] top_state; // 0: walking, 1: falling, 2: digging

// Sub-state machines
reg walk_direction; // 0: left, 1: right
reg digging_status; // 0: not digging, 1: digging

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        top_state <= 0; // walking
        walk_direction <= 0; // left
        digging_status <= 0; // not digging
    end else begin
        case (top_state)
            0: begin // walking
                if (!ground) begin
                    top_state <= 1; // falling
                end else if (dig && ground) begin
                    top_state <= 2; // digging
                    digging_status <= 1; // start digging
                end else if (bump_left) begin
                    walk_direction <= 1; // right
                end else if (bump_right) begin
                    walk_direction <= 0; // left
                end
            end
            1: begin // falling
                if (ground) begin
                    top_state <= 0; // walking
                end
            end
            2: begin // digging
                if (!ground) begin
                    top_state <= 1; // falling
                    digging_status <= 0; // stop digging
                end
            end
        endcase
    end
end

always_comb begin
    walk_left = (top_state == 0 && !walk_direction) ? 1'b1 : 1'b0;
    walk_right = (top_state == 0 && walk_direction) ? 1'b1 : 1'b0;
    aaah = (top_state == 1) ? 1'b1 : 1'b0;
    digging = digging_status;
end

endmodule