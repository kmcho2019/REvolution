module TopModule (
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
    // State encoding - 2 bits
    parameter WALK = 2'b00;
    parameter FALL = 2'b01;
    parameter DIG  = 2'b10;
    
    reg [1:0] state, next_state;
    reg direction, next_direction; // 0=left, 1=right
    
    // Combinational next state logic
    always @(*) begin
        next_state = state;
        next_direction = direction;
        
        case (state)
            WALK: begin
                // Priority: fall > dig > bump
                if (~ground) begin
                    next_state = FALL;
                end else if (dig) begin
                    next_state = DIG;
                end else if ((~direction & bump_left) | (direction & bump_right)) begin
                    next_direction = ~direction;
                end
            end
            
            FALL: begin
                if (ground) begin
                    next_state = WALK;
                end
            end
            
            DIG: begin
                if (~ground) begin
                    next_state = FALL;
                end
            end
        endcase
    end
    
    // Sequential logic with registered outputs
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 1'b0; // Start walking left
            walk_left <= 1'b1;
            walk_right <= 1'b0;
            aaah <= 1'b0;
            digging <= 1'b0;
        end else begin
            state <= next_state;
            direction <= next_direction;
            
            // Registered outputs
            walk_left <= (next_state == WALK) & ~next_direction;
            walk_right <= (next_state == WALK) & next_direction;
            aaah <= (next_state == FALL);
            digging <= (next_state == DIG);
        end
    end
endmodule