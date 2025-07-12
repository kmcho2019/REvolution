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

    // State encoding
    localparam WALK  = 2'b00;
    localparam FALL  = 2'b01;
    localparam DIG   = 2'b10;
    localparam SPLAT = 2'b11;
    
    reg [1:0] state, next_state;
    reg dir, next_dir;  // 0=left, 1=right
    reg [4:0] fall_counter, next_fall_counter;

    // State and direction transition
    always @(*) begin
        next_state = state;
        next_dir = dir;
        next_fall_counter = fall_counter;
        
        case (state)
            WALK: begin
                if (~ground) begin
                    next_state = FALL;
                    next_fall_counter = 0;
                end else if (dig) begin
                    next_state = DIG;
                end else if (bump_left || bump_right) begin
                    next_dir = bump_left;
                end
            end
            
            FALL: begin
                if (ground) begin
                    if (fall_counter > 20)
                        next_state = SPLAT;
                    else
                        next_state = WALK;
                end else begin
                    next_fall_counter = fall_counter + 1;
                end
            end
            
            DIG: begin
                if (~ground) begin
                    next_state = FALL;
                    next_fall_counter = 0;
                end else if (~dig) begin
                    next_state = WALK;
                end
            end
            
            SPLAT: begin
                // Stay in SPLAT forever
            end
        endcase
    end

    // Sequential logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            dir <= 0;
            fall_counter <= 0;
        end else begin
            state <= next_state;
            dir <= next_dir;
            fall_counter <= next_fall_counter;
        end
    end

    // Output logic
    assign walk_left = (state == WALK) & ~dir;
    assign walk_right = (state == WALK) & dir;
    assign aaah = (state == FALL);
    assign digging = (state == DIG);

endmodule