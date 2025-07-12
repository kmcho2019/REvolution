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

reg [2:0] state; // WALKING, FALLING, DIGGING, SPLATTERED
reg [4:0] fall_count;
reg walking_direction;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 3'b001; // WALKING
        walking_direction <= 1'b0; // walking left
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        digging <= 1'b0;
        aaah <= 1'b0;
        fall_count <= 5'b0;
    end else begin
        case (state)
            3'b001: begin // WALKING
                if (!ground) begin
                    state <= 3'b010; // FALLING
                    fall_count <= 5'b1;
                end else if (dig && (walking_direction == 1'b0 || walking_direction == 1'b1)) begin
                    state <= 3'b011; // DIGGING
                end else if (bump_left || bump_right) begin
                    walking_direction <= ~walking_direction;
                end
            end
            3'b010: begin // FALLING
                if (ground) begin
                    if (fall_count > 5'd20) begin
                        state <= 3'b100; // SPLATTERED
                    end else begin
                        state <= 3'b001; // WALKING
                        fall_count <= 5'b0;
                    end
                end else begin
                    fall_count <= fall_count + 1'b1;
                end
            end
            3'b011: begin // DIGGING
                if (!ground) begin
                    state <= 3'b010; // FALLING
                end else if (!dig) begin
                    state <= 3'b001; // WALKING
                end
            end
            3'b100: begin // SPLATTERED
                state <= 3'b100;
            end
        endcase
    end
end

always @(*) begin
    if (state == 3'b100) begin // SPLATTERED
        walk_left <= 1'b0;
        walk_right <= 1'b0;
        digging <= 1'b0;
        aaah <= 1'b0;
    end else if (state == 3'b001) begin // WALKING
        walk_left <= ~walking_direction;
        walk_right <= walking_direction;
        digging <= 1'b0;
        aaah <= 1'b0;
    end else if (state == 3'b010) begin // FALLING
        walk_left <= 1'b0;
        walk_right <= 1'b0;
        digging <= 1'b0;
        aaah <= 1'b1;
    end else if (state == 3'b011) begin // DIGGING
        walk_left <= 1'b0;
        walk_right <= 1'b0;
        digging <= 1'b1;
        aaah <= 1'b0;
    end
end

endmodule