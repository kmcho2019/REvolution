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

reg [4:0] fall_counter; // counter to track number of clock cycles spent falling
reg [1:0] state; // state register (2 bits for 4 states)
reg [1:0] next_state; // next state register
reg walk_left_out, walk_right_out, aaah_out, digging_out; // output registers

// state encoding
parameter WALK_LEFT = 2'b00;
parameter WALK_RIGHT = 2'b01;
parameter FALLING = 2'b10;
parameter DIGGING = 2'b11;
parameter SPLATTERED = 2'b00; // reuse WALK_LEFT encoding for SPLATTERED

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        fall_counter <= 0;
    end else begin
        state <= next_state;
        if (next_state == FALLING) begin
            fall_counter <= fall_counter + 1;
        end else if (next_state == WALK_LEFT || next_state == WALK_RIGHT) begin
            fall_counter <= 0;
        end
    end
end

always @(*) begin
    walk_left_out = 0;
    walk_right_out = 0;
    aaah_out = 0;
    digging_out = 0;
    
    next_state = state;
    
    case (state)
        WALK_LEFT: begin
            if (dig && ground) begin
                next_state = DIGGING;
            end else if (!ground) begin
                next_state = FALLING;
            end else if (bump_right) begin
                next_state = WALK_RIGHT;
            end
            walk_left_out = 1;
        end
        WALK_RIGHT: begin
            if (dig && ground) begin
                next_state = DIGGING;
            end else if (!ground) begin
                next_state = FALLING;
            end else if (bump_left) begin
                next_state = WALK_LEFT;
            end
            walk_right_out = 1;
        end
        FALLING: begin
            if (ground) begin
                if (fall_counter > 20) begin
                    next_state = SPLATTERED;
                end else begin
                    next_state = (state == WALK_LEFT) ? WALK_LEFT : WALK_RIGHT;
                end
            end
            aaah_out = 1;
        end
        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
            end
            digging_out = 1;
        end
        SPLATTERED: begin
            next_state = SPLATTERED;
        end
    endcase
end

assign walk_left = (state == WALK_LEFT && state != SPLATTERED) ? walk_left_out : 0;
assign walk_right = (state == WALK_RIGHT && state != SPLATTERED) ? walk_right_out : 0;
assign aaah = (state == FALLING && state != SPLATTERED) ? aaah_out : 0;
assign digging = (state == DIGGING && state != SPLATTERED) ? digging_out : 0;

endmodule