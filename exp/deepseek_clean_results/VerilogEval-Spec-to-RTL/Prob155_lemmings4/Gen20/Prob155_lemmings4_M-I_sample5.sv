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

    // One-hot state encoding
    parameter WALK  = 4'b0001;
    parameter DIG   = 4'b0010;
    parameter FALL  = 4'b0100;
    parameter SPLAT = 4'b1000;
    
    reg [3:0] state;
    reg direction;  // 0=left, 1=right
    reg [4:0] fall_counter;
    
    // Next state logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 0;
            fall_counter <= 0;
        end else begin
            case (state)
                WALK: begin
                    if (!ground) begin
                        state <= FALL;
                        fall_counter <= 1;
                    end else if (dig) begin
                        state <= DIG;
                    end else if (bump_left || bump_right) begin
                        direction <= bump_left ? 1'b1 : 1'b0;
                    end
                end
                
                DIG: begin
                    if (!ground) begin
                        state <= FALL;
                        fall_counter <= 1;
                    end
                end
                
                FALL: begin
                    if (ground) begin
                        if (fall_counter > 20) begin
                            state <= SPLAT;
                        end else begin
                            state <= WALK;
                        end
                    end else begin
                        fall_counter <= fall_counter + 1;
                    end
                end
                
                SPLAT: begin
                    // Stay in splat state forever
                    state <= SPLAT;
                end
            endcase
        end
    end
    
    // Output logic - pure Moore machine
    assign walk_left = (state == WALK) && !direction;
    assign walk_right = (state == WALK) && direction;
    assign aaah = (state == FALL);
    assign digging = (state == DIG);

endmodule