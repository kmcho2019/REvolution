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
    parameter WALK = 2'b00;
    parameter FALL = 2'b01;
    parameter DIG  = 2'b10;
    parameter SPLAT = 2'b11;
    
    reg [1:0] state, next_state;
    reg direction;  // 0=right, 1=left
    reg [4:0] fall_counter;
    
    // State transition logic
    always @(*) begin
        next_state = state;
        
        case (state)
            WALK: begin
                if (!ground)
                    next_state = FALL;
                else if (dig)
                    next_state = DIG;
                else if ((direction && bump_left) || (!direction && bump_right))
                    direction = ~direction;
            end
            
            FALL: begin
                if (ground) begin
                    if (fall_counter > 20)
                        next_state = SPLAT;
                    else
                        next_state = WALK;
                end
            end
            
            DIG: begin
                if (!ground)
                    next_state = FALL;
            end
            
            SPLAT: begin
                next_state = SPLAT;
            end
        endcase
    end
    
    // Sequential logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 1'b1;  // Start walking left
            fall_counter <= 0;
        end else begin
            state <= next_state;
            
            // Update fall counter
            if (state == FALL) begin
                fall_counter <= (!ground) ? fall_counter + 1 : 0;
            end else begin
                fall_counter <= 0;
            end
        end
    end
    
    // Output logic
    assign walk_left  = (state == WALK) && direction && (state != SPLAT);
    assign walk_right = (state == WALK) && !direction && (state != SPLAT);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);
    
endmodule