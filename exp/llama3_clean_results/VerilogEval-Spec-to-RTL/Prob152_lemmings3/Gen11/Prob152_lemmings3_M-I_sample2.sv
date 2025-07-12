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
reg [0:0] direction;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // Initial state: walking left
        direction <= 1'b0; // Initial direction: left
    end else begin
        case (state)
            2'b00: begin // Walking
                if (!ground) begin
                    state <= 2'b01; // Transition to falling
                end else if (dig) begin
                    state <= 2'b10; // Transition to digging
                end else if ((bump_left && !direction) || (bump_right && direction)) begin
                    direction <= ~direction; // Change direction
                end
            end
            2'b01: begin // Falling
                if (ground) begin
                    state <= 2'b00; // Transition back to walking
                end
            end
            2'b10: begin // Digging
                if (!ground) begin
                    state <= 2'b01; // Transition to falling
                end
            end
        endcase
    end
end

assign walk_left = (state == 2'b00 && !direction);
assign walk_right = (state == 2'b00 && direction);
assign aaah = (state == 2'b01);
assign digging = (state == 2'b10);

endmodule