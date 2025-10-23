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

reg [1:0] state; // 0: walking, 1: falling, 2: digging
reg walk_direction; // 0: left, 1: right

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // walking
        walk_direction <= 0; // left
    end else begin
        case (state)
            2'b00: begin // walking
                if (!ground) begin
                    state <= 2'b01; // falling
                end else if (dig && ground) begin
                    state <= 2'b10; // digging
                end else if (bump_left) begin
                    walk_direction <= 1; // right
                end else if (bump_right) begin
                    walk_direction <= 0; // left
                end
            end
            2'b01: begin // falling
                if (ground) begin
                    state <= 2'b00; // walking
                end
            end
            2'b10: begin // digging
                if (!ground) begin
                    state <= 2'b01; // falling
                end
            end
        endcase
    end
end

assign walk_left = (state == 2'b00 &&!walk_direction)? 1'b1 : 1'b0;
assign walk_right = (state == 2'b00 && walk_direction)? 1'b1 : 1'b0;
assign aaah = (state == 2'b01)? 1'b1 : 1'b0;
assign digging = (state == 2'b10)? 1'b1 : 1'b0;

endmodule