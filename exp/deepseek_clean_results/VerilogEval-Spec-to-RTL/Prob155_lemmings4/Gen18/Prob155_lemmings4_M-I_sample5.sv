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
    parameter DIG  = 2'b01;
    parameter FALL = 2'b10;
    parameter SPLAT = 2'b11;
    
    reg [1:0] state;
    reg direction;  // 0=left, 1=right
    reg [4:0] fall_counter;
    
    // Next state logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 0;  // Start walking left
            fall_counter <= 0;
        end else begin
            case (state)
                WALK: begin
                    if (!ground) begin
                        state <= FALL;
                        fall_counter <= 1;
                    end else if (dig && ground) begin
                        state <= DIG;
                    end else if ((direction && bump_right) || (!direction && bump_left)) begin
                        direction <= ~direction;
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
                        fall_counter <= 0;
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