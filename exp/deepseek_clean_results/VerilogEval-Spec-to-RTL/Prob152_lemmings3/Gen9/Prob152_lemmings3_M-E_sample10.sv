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

    // One-hot encoded states
    parameter LEFT  = 4'b0001;
    parameter RIGHT = 4'b0010;
    parameter FALL  = 4'b0100;
    parameter DIG   = 4'b1000;
    
    reg [3:0] state;

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= LEFT;
        end else begin
            case (1'b1) // Synthesis will optimize this to priority logic
                // Highest priority: falling
                (!ground && (state == LEFT || state == RIGHT || state == DIG)): 
                    state <= FALL;
                // Next priority: digging when on ground and in walking state
                (ground && dig && (state == LEFT || state == RIGHT)):
                    state <= DIG;
                // Then handle bump directions when walking
                (state == LEFT && bump_left):
                    state <= RIGHT;
                (state == RIGHT && bump_right):
                    state <= LEFT;
                // Return from falling when ground reappears
                (state == FALL && ground):
                    state <= (state[0] ? LEFT : RIGHT); // Restore previous direction
                // Stay in DIG state while ground remains
                (state == DIG && ground):
                    state <= DIG;
                default: ; // Maintain current state
            endcase
        end
    end

    // Direct output mapping from state bits
    assign walk_left  = state[0];
    assign walk_right = state[1];
    assign aaah       = state[2];
    assign digging    = state[3];

endmodule