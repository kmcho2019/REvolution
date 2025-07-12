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

// States
parameter WALK_LEFT = 4'b0001;
parameter WALK_RIGHT = 4'b0010;
parameter FALLING = 4'b0100;
parameter DIGGING = 4'b1000;
parameter SPLATTERED = 4'b0000;

// Current state
reg [3:0] state;
reg [3:0] next_state;

// Counters
reg [5:0] fall_counter;
reg [5:0] dig_counter;

always @ (posedge clk or posedge areset)
begin
    if (areset) begin
        state <= WALK_LEFT;
        fall_counter <= 0;
        dig_counter <= 0;
    end else begin
        state <= next_state;
        if (state == FALLING) begin
            fall_counter <= fall_counter + 1;
        end else begin
            fall_counter <= 0;
        end
        if (state == DIGGING) begin
            dig_counter <= dig_counter + 1;
        end else begin
            dig_counter <= 0;
        end
    end
end

always @ (*)
begin
    next_state = state;
    case (state)
        WALK_LEFT:
            begin
                walk_left = 1'b1;
                walk_right = 1'b0;
                aaah = 1'b0;
                digging = 1'b0;
                if (bump_left) begin
                    next_state = WALK_RIGHT;
                end else if (bump_right == 1'b0 && bump_left == 1'b0 && dig && ground) begin
                    next_state = DIGGING;
                end else if (!ground) begin
                    next_state = FALLING;
                end
            end
        WALK_RIGHT:
            begin
                walk_left = 1'b0;
                walk_right = 1'b1;
                aaah = 1'b0;
                digging = 1'b0;
                if (bump_right) begin
                    next_state = WALK_LEFT;
                end else if (bump_left == 1'b0 && bump_right == 1'b0 && dig && ground) begin
                    next_state = DIGGING;
                end else if (!ground) begin
                    next_state = FALLING;
                end
            end
        FALLING:
            begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b1;
                digging = 1'b0;
                if (ground) begin
                    if (fall_counter > 20) begin
                        next_state = SPLATTERED;
                    end else if (state == WALK_LEFT) begin
                        next_state = WALK_LEFT;
                    end else begin
                        next_state = WALK_RIGHT;
                    end
                end
            end
        DIGGING:
            begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b0;
                digging = 1'b1;
                if (!ground) begin
                    next_state = FALLING;
                end
            end
        SPLATTERED:
            begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b0;
                digging = 1'b0;
            end
        default:
            begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b0;
                digging = 1'b0;
            end
    endcase
end

endmodule