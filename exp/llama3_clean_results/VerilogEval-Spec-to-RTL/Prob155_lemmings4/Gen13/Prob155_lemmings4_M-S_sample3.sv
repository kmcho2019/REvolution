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
reg [4:0] fall_count;
reg direction;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // WALKING
        fall_count <= 5'b0;
        direction <= 1'b1; // left
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
        digging <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // WALKING
                if (!ground) begin
                    state <= 2'b01; // FALLING
                    fall_count <= 5'b1;
                end else if (dig) begin
                    state <= 2'b10; // DIGGING
                end else if (bump_left || (bump_left && bump_right)) begin
                    direction <= 1'b0; // right
                end else if (bump_right || (bump_left && bump_right)) begin
                    direction <= 1'b1; // left
                end
                walk_left <= direction;
                walk_right <= ~direction;
                aaah <= 1'b0;
                digging <= 1'b0;
            end
            2'b01: begin // FALLING
                if (ground) begin
                    if (fall_count > 5'd20) begin
                        state <= 2'b11; // SPLATTERED
                    end else begin
                        state <= 2'b00; // WALKING
                    end
                end else begin
                    fall_count <= fall_count + 1'b1;
                end
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b1;
                digging <= 1'b0;
            end
            2'b10: begin // DIGGING
                if (!ground) begin
                    state <= 2'b01; // FALLING
                    fall_count <= 5'b1;
                end else if (!dig) begin
                    state <= 2'b00; // WALKING
                end
                walk_left <= direction;
                walk_right <= ~direction;
                aaah <= 1'b0;
                digging <= 1'b1;
            end
            2'b11: begin // SPLATTERED
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b0;
                digging <= 1'b0;
            end
        endcase
    end
end

endmodule