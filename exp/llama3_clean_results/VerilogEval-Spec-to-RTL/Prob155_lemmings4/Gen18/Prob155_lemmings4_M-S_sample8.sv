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

reg [1:0] current_state;
reg [1:0] next_state;
reg [4:0] fall_counter;
reg direction;
reg is_digging;

always_comb begin
    case (current_state)
        2'b00: begin // WALK_LEFT
            if (~ground) begin
                next_state = 2'b01; // FALLING
            end else if (dig) begin
                next_state = 2'b00;
                is_digging = 1'b1;
            end else if (bump_left) begin
                next_state = 2'b10; // WALK_RIGHT
                direction = 1'b0;
            end else begin
                next_state = 2'b00;
            end
        end
        2'b10: begin // WALK_RIGHT
            if (~ground) begin
                next_state = 2'b01; // FALLING
            end else if (dig) begin
                next_state = 2'b10;
                is_digging = 1'b1;
            end else if (bump_right) begin
                next_state = 2'b00; // WALK_LEFT
                direction = 1'b1;
            end else begin
                next_state = 2'b10;
            end
        end
        2'b01: begin // FALLING
            if (ground) begin
                if (fall_counter > 5'd20) begin
                    next_state = 2'b11; // SPLATTER
                end else begin
                    next_state = direction? 2'b00 : 2'b10;
                end
            end else begin
                next_state = 2'b01;
            end
        end
        2'b11: begin // SPLATTER
            next_state = 2'b11;
        end
        default: begin
            next_state = 2'b00;
        end
    endcase
end

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= 2'b00;
        fall_counter <= 5'b0;
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
        digging <= 1'b0;
        direction <= 1'b1;
        is_digging <= 1'b0;
    end else begin
        current_state <= next_state;
        if (~ground) begin
            fall_counter <= fall_counter + 1'b1;
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b1;
            digging <= 1'b0;
        end else if (current_state == 2'b01) begin
            fall_counter <= 5'b0;
            if (current_state == 2'b11) begin
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b0;
                digging <= 1'b0;
            end else begin
                walk_left <= direction? 1'b1 : 1'b0;
                walk_right <= direction? 1'b0 : 1'b1;
                aaah <= 1'b0;
                digging <= 1'b0;
            end
        end else if (is_digging) begin
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b0;
            digging <= 1'b1;
        end else begin
            walk_left <= current_state == 2'b00? 1'b1 : 1'b0;
            walk_right <= current_state == 2'b10? 1'b1 : 1'b0;
            aaah <= 1'b0;
            digging <= 1'b0;
        end
        if (~dig) begin
            is_digging <= 1'b0;
        end
    end
end

endmodule