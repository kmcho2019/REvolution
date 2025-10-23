module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

reg [1:0] state;
reg walk_direction;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0;
        walk_direction <= 0;
    end else begin
        case (state)
            0: begin // walking
                if (!ground) begin
                    state <= 1; // fall
                end else if (dig) begin
                    state <= 2; // dig
                end else if (bump_left || bump_right) begin
                    walk_direction <= ~walk_direction;
                end
            end
            1: begin // falling
                if (ground) begin
                    state <= 0; // resume walking
                end
            end
            2: begin // digging
                if (!ground) begin
                    state <= 1; // fall
                end
            end
            default: begin
                state <= 0;
            end
        endcase
    end
end

assign walk_left = (state == 0 && !walk_direction);
assign walk_right = (state == 0 && walk_direction);
assign aaah = (state == 1);
assign digging = (state == 2);

endmodule