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
reg [4:0] fall_counter;
reg walk_direction;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // WALKING
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
        digging <= 1'b0;
        fall_counter <= 5'b0;
        walk_direction <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // WALKING
                if (~ground) begin
                    state <= 2'b01; // FALLING
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                    digging <= 1'b0;
                    fall_counter <= 5'b1;
                end else if (dig && ground) begin
                    state <= 2'b10; // DIGGING
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                    digging <= 1'b1;
                end else if (bump_left && ~bump_right) begin
                    walk_direction <= 1'b1;
                end else if (~bump_left && bump_right) begin
                    walk_direction <= 1'b0;
                end
                walk_left <= ~walk_direction;
                walk_right <= walk_direction;
            end
            2'b01: begin // FALLING
                if (ground) begin
                    if (fall_counter > 5'd20) begin
                        state <= 2'b11; // SPLATTERED
                        walk_left <= 1'b0;
                        walk_right <= 1'b0;
                        aaah <= 1'b0;
                        digging <= 1'b0;
                    end else begin
                        state <= 2'b00; // WALKING
                        walk_left <= ~walk_direction;
                        walk_right <= walk_direction;
                        aaah <= 1'b0;
                        digging <= 1'b0;
                    end
                    fall_counter <= 5'b0;
                end else begin
                    fall_counter <= fall_counter + 1'b1;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                    digging <= 1'b0;
                end
            end
            2'b10: begin // DIGGING
                if (~ground) begin
                    state <= 2'b01; // FALLING
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                    digging <= 1'b0;
                    fall_counter <= 5'b1;
                end else begin
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                    digging <= 1'b1;
                end
            end
            2'b11: begin // SPLATTERED
                state <= 2'b11; // SPLATTERED
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b0;
                digging <= 1'b0;
            end
        endcase
    end
end

endmodule