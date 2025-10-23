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

    // Main Activity States
    parameter MAIN_WALK = 2'b00;
    parameter MAIN_DIG  = 2'b01;
    parameter MAIN_FALL = 2'b10;
    parameter MAIN_SPLAT = 2'b11;
    
    // Direction States
    parameter DIR_LEFT = 1'b1;
    parameter DIR_RIGHT = 1'b0;

    reg [1:0] main_state;
    reg direction;
    reg [4:0] fall_counter;

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            main_state <= MAIN_WALK;
            direction <= DIR_LEFT;
            fall_counter <= 0;
        end else begin
            case (main_state)
                MAIN_WALK: begin
                    if (!ground) begin
                        main_state <= MAIN_FALL;
                        fall_counter <= 1;
                    end else if (dig) begin
                        main_state <= MAIN_DIG;
                    end else if (bump_left || bump_right) begin
                        direction <= bump_left ? DIR_LEFT : DIR_RIGHT;
                    end
                end
                
                MAIN_DIG: begin
                    if (!ground) begin
                        main_state <= MAIN_FALL;
                        fall_counter <= 1;
                    end
                end
                
                MAIN_FALL: begin
                    if (ground) begin
                        if (fall_counter > 20) begin
                            main_state <= MAIN_SPLAT;
                        end else begin
                            main_state <= MAIN_WALK;
                        end
                        fall_counter <= 0;
                    end else begin
                        fall_counter <= fall_counter + 1;
                    end
                end
                
                MAIN_SPLAT: begin
                    // Stay in SPLAT state forever
                end
            endcase
        end
    end

    // Output logic
    assign walk_left = (main_state == MAIN_WALK) && direction;
    assign walk_right = (main_state == MAIN_WALK) && !direction;
    assign aaah = (main_state == MAIN_FALL);
    assign digging = (main_state == MAIN_DIG);

endmodule