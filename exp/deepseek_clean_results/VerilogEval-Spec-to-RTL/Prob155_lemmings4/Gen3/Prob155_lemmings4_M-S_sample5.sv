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

    // State definitions
    reg [1:0] state;
    reg direction;  // 0=left, 1=right
    reg [4:0] fall_counter;
    
    localparam WALK = 2'b00;
    localparam FALL = 2'b01;
    localparam DIG  = 2'b10;
    localparam SPLAT = 2'b11;

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
                        fall_counter <= 0;
                    end else if (dig) begin
                        state <= DIG;
                    end else if ((bump_left && !direction) || (bump_right && direction)) begin
                        direction <= ~direction;
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
                    if (!ground) begin
                        state <= FALL;
                        fall_counter <= 0;
                    end
                end
                
                SPLAT: begin
                    // Stay in splattered state
                end
            endcase
        end
    end

    // Output logic
    assign walk_left = (state == WALK) && !direction;
    assign walk_right = (state == WALK) && direction;
    assign aaah = (state == FALL);
    assign digging = (state == DIG);

endmodule