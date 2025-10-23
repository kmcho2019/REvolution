module TopModule(
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

// States
localparam IDLE = 2'b00; // walking left
localparam WALKING = 2'b01; // walking right
localparam FALLING = 2'b10; // falling
localparam SPLATTERED = 2'b11; // splattered

reg [1:0] current_state, next_state;
reg [5:0] fall_counter, next_fall_counter;

always_comb begin
    next_state = current_state;
    next_fall_counter = fall_counter;
    case (current_state)
        IDLE: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = IDLE; // digging, but still walking left
                digging = 1'b1;
            end else if (bump_right) begin
                next_state = WALKING;
            end
        end
        WALKING: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = WALKING; // digging, but still walking right
                digging = 1'b1;
            end else if (bump_left) begin
                next_state = IDLE;
            end
        end
        FALLING: begin
            next_fall_counter = fall_counter + 1'b1;
            if (ground) begin
                if (fall_counter > 20) begin
                    next_state = SPLATTERED;
                end else begin
                    if (current_state == IDLE) begin
                        next_state = IDLE;
                    end else begin
                        next_state = WALKING;
                    end
                end
                next_fall_counter = 0;
            end
        end
        SPLATTERED: begin
            next_state = SPLATTERED;
        end
        default: next_state = IDLE;
    endcase
end

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= IDLE;
        fall_counter <= 0;
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
        digging <= 1'b0;
    end else begin
        current_state <= next_state;
        fall_counter <= next_fall_counter;
        case (next_state)
            IDLE: begin
                walk_left <= 1'b1;
                walk_right <= 1'b0;
                aaah <= 1'b0;
                digging <= dig;
            end
            WALKING: begin
                walk_left <= 1'b0;
                walk_right <= 1'b1;
                aaah <= 1'b0;
                digging <= dig;
            end
            FALLING: begin
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b1;
                digging <= 1'b0;
            end
            SPLATTERED: begin
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b0;
                digging <= 1'b0;
            end
            default: begin
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b0;
                digging <= 1'b0;
            end
        endcase
    end
end

endmodule