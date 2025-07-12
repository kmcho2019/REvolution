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
        state <= 2'b00; // walking
        direction <= 1'b0; // left
    end else begin
        case (state)
            2'b00: begin // walking
                if (!ground) begin
                    state <= 2'b01; // falling
                end else if (dig) begin
                    state <= 2'b10; // digging
                end else if (bump_left && direction == 1'b0) begin
                    direction <= 1'b1; // right
                end else if (bump_right && direction == 1'b1) begin
                    direction <= 1'b0; // left
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

always @(*) begin
    case (state)
        2'b00: begin // walking
            walk_left <= direction == 1'b0;
            walk_right <= direction == 1'b1;
            aaah <= 0;
            digging <= 0;
        end
        2'b01: begin // falling
            walk_left <= 0;
            walk_right <= 0;
            aaah <= 1;
            digging <= 0;
        end
        2'b10: begin // digging
            walk_left <= 0;
            walk_right <= 0;
            aaah <= 0;
            digging <= 1;
        end
    endcase
end

endmodule