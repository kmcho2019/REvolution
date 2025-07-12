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
    localparam WALK  = 2'b00;
    localparam FALL  = 2'b01;
    localparam DIG   = 2'b10;
    localparam SPLAT = 2'b11;
    
    reg [1:0] state;
    reg direction;  // 0=left, 1=right
    reg [4:0] fall_counter;

    // Direction logic (independent of state)
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            direction <= 0;
        end else if (state == WALK && ground && !dig) begin
            if (bump_left) direction <= 1;
            else if (bump_right) direction <= 0;
        end
    end

    // Fall counter logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            fall_counter <= 0;
        end else begin
            if (state == FALL && !ground)
                fall_counter <= fall_counter + 1;
            else
                fall_counter <= 0;
        end
    end

    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
        end else begin
            case (state)
                WALK: begin
                    if (!ground)
                        state <= FALL;
                    else if (dig)
                        state <= DIG;
                end
                
                FALL: begin
                    if (ground) begin
                        state <= (fall_counter > 20) ? SPLAT : WALK;
                    end
                end
                
                DIG: begin
                    if (!ground)
                        state <= FALL;
                    else if (!dig)
                        state <= WALK;
                end
                
                SPLAT: begin
                    state <= SPLAT;
                end
            endcase
        end
    end

    // Output assignments
    assign walk_left = (state == WALK) && !direction;
    assign walk_right = (state == WALK) && direction;
    assign aaah = (state == FALL);
    assign digging = (state == DIG);

endmodule