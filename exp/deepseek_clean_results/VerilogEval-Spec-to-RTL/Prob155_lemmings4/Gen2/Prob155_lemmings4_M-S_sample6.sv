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
    parameter FALL = 2'd1;
    parameter DIG = 2'd2;
    parameter SPLAT = 2'd3;
    
    reg [1:0] state;
    reg dir;  // 0=left, 1=right
    reg [4:0] fall_counter;

    // State transition
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            dir <= 0;
            fall_counter <= 0;
        end else begin
            case (state)
                WALK: begin
                    if (~ground) begin
                        state <= FALL;
                        fall_counter <= 0;
                    end else if (dig) begin
                        state <= DIG;
                    end else begin
                        if (bump_left) dir <= 1;
                        if (bump_right) dir <= 0;
                    end
                end
                
                FALL: begin
                    if (ground) begin
                        if (fall_counter > 20)
                            state <= SPLAT;
                        else
                            state <= WALK;
                    end else begin
                        fall_counter <= fall_counter + 1;
                    end
                end
                
                DIG: begin
                    if (~ground) begin
                        state <= FALL;
                        fall_counter <= 0;
                    end
                end
                
                SPLAT: begin
                    // Stay in SPLAT forever
                end
            endcase
        end
    end

    // Output logic
    assign walk_left = (state == WALK) & ~dir;
    assign walk_right = (state == WALK) & dir;
    assign aaah = (state == FALL);
    assign digging = (state == DIG);

endmodule