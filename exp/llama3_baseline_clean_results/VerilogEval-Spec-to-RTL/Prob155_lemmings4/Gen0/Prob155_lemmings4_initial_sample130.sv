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
reg [4:0] fall_count;
reg direction;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00;
        direction <= 1'b0;
        fall_count <= 5'b0;
    end else begin
        case (state)
            2'b00: begin // walking
                if (!ground) begin
                    state <= 2'b01;
                end else if (dig && direction == 1'b0 && bump_left == 1'b0 && bump_right == 1'b0) begin
                    state <= 2'b10;
                end else if (dig && direction == 1'b1 && bump_left == 1'b0 && bump_right == 1'b0) begin
                    state <= 2'b10;
                end else if (bump_left || bump_right) begin
                    direction <= ~direction;
                end
            end
            2'b01: begin // falling
                fall_count <= fall_count + 1;
                if (ground) begin
                    if (fall_count > 5'b10100) begin // 20 clock cycles
                        state <= 2'b11;
                    end else begin
                        state <= 2'b00;
                    end
                    fall_count <= 5'b0;
                end
            end
            2'b10: begin // digging
                if (!ground) begin
                    state <= 2'b01;
                end
            end
            2'b11: begin // splattered
                // do nothing
            end
        endcase
    end
end

always @(*) begin
    case (state)
        2'b00: begin // walking
            walk_left = direction ? 1'b0 : 1'b1;
            walk_right = direction ? 1'b1 : 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
        2'b01: begin // falling
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
        end
        2'b10: begin // digging
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
        end
        2'b11: begin // splattered
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
    endcase
end

endmodule