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
    // Combined state and direction encoding
    parameter WALK_LEFT  = 2'b00;
    parameter WALK_RIGHT = 2'b01;
    parameter FALL       = 2'b10;
    parameter DIG        = 2'b11;
    
    reg [1:0] state;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
        end else begin
            case (state)
                WALK_LEFT, WALK_RIGHT: begin
                    if (~ground) begin
                        state <= FALL;
                    end else if (dig) begin
                        state <= DIG;
                    end else if ((state == WALK_LEFT && bump_left) || 
                                (state == WALK_RIGHT && bump_right)) begin
                        state <= ~state[0]; // Toggle direction
                    end
                end
                
                FALL: begin
                    if (ground) begin
                        state <= state[1:0]; // Return to previous walking state
                    end
                end
                
                DIG: begin
                    if (~ground) begin
                        state <= FALL;
                    end
                end
            endcase
        end
    end
    
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);
    
endmodule