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
    parameter WALK = 2'b00;
    parameter FALL = 2'b01;
    parameter DIG  = 2'b10;
    reg [1:0] state;

    // Direction
    reg direction; // 0=left, 1=right
    
    // Fall counter
    reg [4:0] fall_cycles;
    wire splat = (state == FALL) && ground && (fall_cycles > 20);

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 0;
            fall_cycles <= 0;
        end else if (splat) begin
            state <= WALK; // All outputs will be 0
        end else begin
            case (state)
                WALK: begin
                    if (~ground) begin
                        state <= FALL;
                        fall_cycles <= 1;
                    end else if (dig) begin
                        state <= DIG;
                    end else if (bump_left || bump_right) begin
                        direction <= bump_left ? 1 : 0;
                    end
                end
                
                DIG: begin
                    if (~ground) begin
                        state <= FALL;
                        fall_cycles <= 1;
                    end
                end
                
                FALL: begin
                    if (ground) begin
                        state <= WALK;
                        fall_cycles <= 0;
                    end else begin
                        fall_cycles <= fall_cycles + 1;
                    end
                end
            endcase
        end
    end

    // Outputs
    assign walk_left = (state == WALK) && ~direction && ~splat;
    assign walk_right = (state == WALK) && direction && ~splat;
    assign aaah = (state == FALL);
    assign digging = (state == DIG);
    
endmodule