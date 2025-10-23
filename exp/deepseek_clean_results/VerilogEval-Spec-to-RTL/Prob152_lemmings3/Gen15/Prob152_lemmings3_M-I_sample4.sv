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
    parameter WALK = 3'b001;
    parameter FALL = 3'b010;
    parameter DIG  = 3'b100;

    reg [2:0] state;
    reg direction; // 0=left, 1=right
    reg direction_en; // Clock enable for direction register

    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
        end
        else case (state)
            WALK: begin
                if (!ground)      state <= FALL;
                else if (dig)     state <= DIG;
            end
            
            FALL: if (ground) state <= WALK;
            
            DIG: if (!ground) state <= FALL;
        endcase
    end

    // Direction logic with clock gating
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            direction <= 0;
        end
        else if (direction_en) begin
            if (bump_left)  direction <= 1;
            if (bump_right) direction <= 0;
        end
    end

    // Clock enable for direction (only update in WALK state with ground)
    always @(*) begin
        direction_en = (state == WALK) && ground && !dig && (bump_left || bump_right);
    end

    // Outputs (simplified with one-hot encoding)
    assign walk_left = (state == WALK) & ~direction;
    assign walk_right = (state == WALK) & direction;
    assign aaah = (state == FALL);
    assign digging = (state == DIG);

endmodule