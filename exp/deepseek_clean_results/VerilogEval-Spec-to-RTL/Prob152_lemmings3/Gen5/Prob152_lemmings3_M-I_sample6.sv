module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

    // Gray-coded states with embedded direction
    parameter WL = 2'b00;  // Walk Left
    parameter WR = 2'b01;  // Walk Right
    parameter FL = 2'b11;  // Fall (direction maintained)
    parameter DG = 2'b10;  // Dig (direction maintained)

    reg [1:0] state, next_state;

    // Combinational transition logic
    always @(*) begin
        case (state)
            WL: begin
                if (!ground) begin
                    next_state = FL;
                end
                else if (dig) begin
                    next_state = DG;
                end
                else if (bump_left) begin
                    next_state = WR;
                end
                else begin
                    next_state = WL;
                end
            end
            
            WR: begin
                if (!ground) begin
                    next_state = FL;
                end
                else if (dig) begin
                    next_state = DG;
                end
                else if (bump_right) begin
                    next_state = WL;
                end
                else begin
                    next_state = WR;
                end
            end
            
            FL: begin
                next_state = ground ? (state[0] ? WR : WL) : FL;
            end
            
            DG: begin
                next_state = ground ? DG : FL;
            end
            
            default: next_state = WL;
        endcase
    end

    // Sequential logic with async reset
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WL;
            {walk_left, walk_right, aaah, digging} <= 4'b1000;
        end
        else begin
            state <= next_state;
            
            // Registered outputs to reduce glitching
            walk_left  <= (next_state == WL);
            walk_right <= (next_state == WR);
            aaah       <= (next_state == FL);
            digging    <= (next_state == DG);
        end
    end

endmodule