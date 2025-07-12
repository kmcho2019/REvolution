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

reg [1:0] state;
reg walking_left;
reg [4:0] fall_counter;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00;
        walking_left <= 1'b1;
        fall_counter <= 5'b0;
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
        digging <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // WALKING
                if (~ground) begin
                    state <= 2'b01;
                    fall_counter <= 1'b1;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                end else if (dig) begin
                    walking_left <= walking_left;
                    digging <= 1'b1;
                end else if (bump_left ^ bump_right) begin
                    walking_left <= ~walking_left;
                    walk_left <= walking_left;
                    walk_right <= ~walking_left;
                end else if (bump_left && bump_right) begin
                    walking_left <= ~walking_left;
                    walk_left <= walking_left;
                    walk_right <= ~walking_left;
                end
            end
            2'b01: begin // FALLING
                fall_counter <= fall_counter + 1'b1;
                if (ground) begin
                    if (fall_counter > 5'd20) begin
                        state <= 2'b10;
                        walk_left <= 1'b0;
                        walk_right <= 1'b0;
                        aaah <= 1'b0;
                        digging <= 1'b0;
                    end else begin
                        state <= 2'b00;
                        walk_left <= walking_left;
                        walk_right <= ~walking_left;
                        aaah <= 1'b0;
                        fall_counter <= 5'b0;
                    end
                end
            end
            2'b10: begin // SPLATTERED
                state <= 2'b10;
            end
        endcase
    end
end

endmodule