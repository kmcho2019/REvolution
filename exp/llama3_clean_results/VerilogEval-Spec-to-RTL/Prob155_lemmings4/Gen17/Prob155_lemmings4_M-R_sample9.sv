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

reg [1:0] current_mode;
reg walking_direction;
reg [4:0] fall_count;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_mode <= 2'b00; // WALK
        walking_direction <= 1'b0; // walking left
        fall_count <= 5'b0;
    end else begin
        case (current_mode)
            2'b00: begin // WALK
                if (!ground) begin
                    current_mode <= 2'b01; // FALL
                    fall_count <= 5'b0;
                end else if (dig) begin
                    current_mode <= 2'b10; // DIG
                end else if (bump_left || bump_right) begin
                    walking_direction <= ~walking_direction;
                end
            end
            2'b01: begin // FALL
                if (ground) begin
                    if (fall_count > 5'd20) begin
                        current_mode <= 2'b11; // STOP
                    end else begin
                        current_mode <= 2'b00; // WALK
                    end
                    fall_count <= 5'b0;
                end else begin
                    fall_count <= fall_count + 1'b1;
                end
            end
            2'b10: begin // DIG
                if (!ground) begin
                    current_mode <= 2'b01; // FALL
                    fall_count <= 5'b0;
                end else if (!dig) begin
                    current_mode <= 2'b00; // WALK
                end
            end
            2'b11: begin // STOP
                // Do nothing
            end
        endcase
    end
end

assign walk_left = (current_mode == 2'b00) && ~walking_direction;
assign walk_right = (current_mode == 2'b00) && walking_direction;
assign aaah = (current_mode == 2'b01);
assign digging = (current_mode == 2'b10);

endmodule