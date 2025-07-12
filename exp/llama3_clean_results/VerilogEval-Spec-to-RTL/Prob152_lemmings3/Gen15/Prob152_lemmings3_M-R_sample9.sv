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
reg walk_direction;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // WALKING
        walk_direction <= 0;
        walk_left <= 1;
        walk_right <= 0;
        aaah <= 0;
        digging <= 0;
    end else begin
        case (state)
            2'b00: begin // WALKING
                if (!ground) begin
                    state <= 2'b01; // FALLING
                end else if (dig) begin
                    state <= 2'b10; // DIGGING
                end else if (bump_left) begin
                    walk_direction <= 1;
                    walk_left <= 0;
                    walk_right <= 1;
                end else if (bump_right) begin
                    walk_direction <= 0;
                    walk_left <= 1;
                    walk_right <= 0;
                end
            end
            2'b01: begin // FALLING
                if (ground) begin
                    state <= 2'b00; // WALKING
                end
            end
            2'b10: begin // DIGGING
                if (!ground) begin
                    state <= 2'b01; // FALLING
                end
            end
        endcase

        // Update outputs
        if (state == 2'b00) begin // WALKING
            walk_left <= !walk_direction;
            walk_right <= walk_direction;
        end else begin
            walk_left <= 0;
            walk_right <= 0;
        end

        aaah <= (state == 2'b01); // FALLING
        digging <= (state == 2'b10); // DIGGING
    end
end

endmodule