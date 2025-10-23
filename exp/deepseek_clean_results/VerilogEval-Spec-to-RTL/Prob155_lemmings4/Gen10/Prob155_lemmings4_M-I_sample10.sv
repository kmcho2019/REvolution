module TopModule (
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
    parameter WALK = 2'd0;
    parameter DIG = 2'd1;
    parameter FALL = 2'd2;
    parameter SPLAT = 2'd3;

    reg [1:0] state, next_state;
    reg [4:0] fall_counter;
    reg direction, next_direction; // 0=left, 1=right

    // State transition logic
    always @(*) begin
        next_state = state;
        next_direction = direction;
        
        case (state)
            WALK: begin
                if (~ground) begin
                    next_state = FALL;
                end else if (dig) begin
                    next_state = DIG;
                end else if (bump_left || bump_right) begin
                    next_direction = bump_left ? 1'b1 : 1'b0;
                end
            end
            
            DIG: begin
                if (~ground) begin
                    next_state = FALL;
                end else if (~dig) begin
                    next_state = WALK;
                end
            end
            
            FALL: begin
                if (ground) begin
                    next_state = (fall_counter >= 5'd20) ? SPLAT : WALK;
                end
            end
            
            SPLAT: next_state = SPLAT;
        endcase
    end

    // Sequential logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 1'b0;
            fall_counter <= 5'd0;
        end else begin
            state <= next_state;
            direction <= next_direction;
            
            // Fall counter logic
            if (state == FALL) begin
                if (~ground) begin
                    fall_counter <= fall_counter + 1'b1;
                end else begin
                    fall_counter <= 5'd0;
                end
            end else begin
                fall_counter <= 5'd0;
            end
        end
    end

    // Output logic
    assign walk_left = (state == WALK) & ~direction;
    assign walk_right = (state == WALK) & direction;
    assign aaah = (state == FALL);
    assign digging = (state == DIG);

endmodule