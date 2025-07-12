module TopModule(
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

reg [1:0] state; // 2'b00: walking, 2'b01: digging, 2'b10: splattered
reg [4:0] fall_counter;
reg walk_direction;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00;
        fall_counter <= 5'b0;
        walk_direction <= 1'b0;
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
        digging <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // walking
                if (~ground) begin
                    fall_counter <= fall_counter + 1'b1;
                    if (fall_counter > 5'd20) begin
                        state <= 2'b10;
                    end
                end else if (dig) begin
                    state <= 2'b01;
                end else if (bump_left || bump_right) begin
                    walk_direction <= ~walk_direction;
                end
            end
            2'b01: begin // digging
                if (~ground) begin
                    state <= 2'b00;
                end
            end
            2'b10: begin // splattered
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b0;
                digging <= 1'b0;
            end
        endcase
    end
end

always_comb begin
    if (state == 2'b10) begin
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b0;
        digging = 1'b0;
    end else if (state == 2'b01) begin
        digging = 1'b1;
        if (walk_direction) begin
            walk_left = 1'b0;
            walk_right = 1'b1;
        end else begin
            walk_left = 1'b1;
            walk_right = 1'b0;
        end
    end else if (~ground) begin
        aaah = 1'b1;
        walk_left = 1'b0;
        walk_right = 1'b0;
        digging = 1'b0;
    end else begin
        aaah = 1'b0;
        if (walk_direction) begin
            walk_left = 1'b0;
            walk_right = 1'b1;
        end else begin
            walk_left = 1'b1;
            walk_right = 1'b0;
        end
        digging = 1'b0;
    end
end

endmodule