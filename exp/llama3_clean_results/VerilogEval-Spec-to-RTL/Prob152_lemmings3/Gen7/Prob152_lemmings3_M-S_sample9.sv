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

reg [1:0] state;
reg direction;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00;
        direction <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // walking
                if (!ground) begin
                    state <= 2'b01;
                end else if (dig) begin
                    // digging is a special case of walking
                end else if (bump_left && !direction) begin
                    direction <= 1'b1;
                end else if (bump_right && direction) begin
                    direction <= 1'b0;
                end
            end
            2'b01: begin // falling
                if (ground) begin
                    state <= 2'b00;
                end
            end
        endcase
    end
end

assign walk_left = (state == 2'b00 && !direction);
assign walk_right = (state == 2'b00 && direction);
assign aaah = (state == 2'b01);
assign digging = (state == 2'b00 && dig && ground);

endmodule