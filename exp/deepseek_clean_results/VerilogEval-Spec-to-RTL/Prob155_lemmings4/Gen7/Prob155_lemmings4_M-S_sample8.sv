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
    localparam WL = 2'b00; // Walking left
    localparam WR = 2'b01; // Walking right
    localparam FL = 2'b10; // Falling
    localparam DG = 2'b11; // Digging

    reg [1:0] state, next_state;
    reg direction; // 0=left, 1=right
    reg [4:0] fall_timer;

    // State transition
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WL;
            direction <= 0;
            fall_timer <= 0;
        end else begin
            state <= next_state;
            
            // Update direction when walking and bumped
            if ((state == WL || state == WR) && ground && ~dig && ~next_state[1]) begin
                if (bump_left) direction <= 1;
                if (bump_right) direction <= 0;
            end
            
            // Update fall timer
            if (state == FL) begin
                if (ground) fall_timer <= 0;
                else fall_timer <= fall_timer + 1;
            end else begin
                fall_timer <= 0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            WL, WR: begin
                if (~ground) next_state = FL;
                else if (dig) next_state = DG;
                else next_state = direction ? WR : WL;
            end
            
            FL: begin
                if (ground)
                    next_state = (fall_timer > 20) ? 2'b00 : (direction ? WR : WL);
                else
                    next_state = FL;
            end
            
            DG: begin
                if (~ground) next_state = FL;
                else next_state = DG;
            end
            
            default: next_state = WL;
        endcase
    end

    // Output logic
    assign walk_left = (state == WL);
    assign walk_right = (state == WR);
    assign aaah = (state == FL);
    assign digging = (state == DG);

endmodule