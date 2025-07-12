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

    // Movement directions
    parameter LEFT = 1'b0;
    parameter RIGHT = 1'b1;
    
    // Action states
    parameter WALK = 2'b00;
    parameter DIG = 2'b01;
    parameter FALL = 2'b10;
    parameter SPLAT = 2'b11;

    reg movement;      // LEFT or RIGHT
    reg [1:0] action;  // Current action state
    reg [4:0] fall_cycles;

    // State transition logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            movement <= LEFT;
            action <= WALK;
            fall_cycles <= 0;
        end else begin
            case (action)
                WALK: begin
                    if (!ground) begin
                        action <= FALL;
                        fall_cycles <= 1;
                    end else if (dig) begin
                        action <= DIG;
                    end else if (bump_left || bump_right) begin
                        // Switch direction if bumped (priority lowest)
                        if ((movement == LEFT && bump_left) || 
                            (movement == RIGHT && bump_right)) begin
                            movement <= ~movement;
                        end
                    end
                end
                
                DIG: begin
                    if (!ground) begin
                        action <= FALL;
                        fall_cycles <= 1;
                    end
                end
                
                FALL: begin
                    if (ground) begin
                        if (fall_cycles > 20) begin
                            action <= SPLAT;
                        end else begin
                            action <= WALK;
                        end
                        fall_cycles <= 0;
                    end else begin
                        fall_cycles <= fall_cycles + 1;
                    end
                end
                
                SPLAT: begin
                    // Permanent state
                end
            endcase
        end
    end

    // Output logic
    assign walk_left = (action == WALK) && (movement == LEFT);
    assign walk_right = (action == WALK) && (movement == RIGHT);
    assign aaah = (action == FALL);
    assign digging = (action == DIG);

endmodule