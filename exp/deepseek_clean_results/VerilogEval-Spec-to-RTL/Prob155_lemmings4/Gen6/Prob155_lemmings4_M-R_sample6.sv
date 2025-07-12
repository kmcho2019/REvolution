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
    localparam WL = 3'b000; // Walking left
    localparam WR = 3'b001; // Walking right
    localparam FL = 3'b010; // Falling (was walking left)
    localparam FR = 3'b011; // Falling (was walking right)
    localparam DG = 3'b100; // Digging
    localparam SP = 3'b101; // Splattered

    reg [2:0] state, next_state;
    reg [4:0] fall_timer;

    // State transition
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WL;
            fall_timer <= 0;
        end else begin
            state <= next_state;
            
            // Update fall timer
            if (state == FL || state == FR)
                fall_timer <= fall_timer + 1;
            else
                fall_timer <= 0;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            WL: begin
                if (~ground)
                    next_state = FL;
                else if (dig)
                    next_state = DG;
                else if (bump_left)
                    next_state = WR;
                else
                    next_state = WL;
            end
            
            WR: begin
                if (~ground)
                    next_state = FR;
                else if (dig)
                    next_state = DG;
                else if (bump_right)
                    next_state = WL;
                else
                    next_state = WR;
            end
            
            FL: begin
                if (ground)
                    next_state = (fall_timer > 20) ? SP : WL;
                else
                    next_state = FL;
            end
            
            FR: begin
                if (ground)
                    next_state = (fall_timer > 20) ? SP : WR;
                else
                    next_state = FR;
            end
            
            DG: begin
                if (~ground)
                    next_state = (state == DG) ? FL : FR; // Maintain direction
                else
                    next_state = DG;
            end
            
            SP: next_state = SP;
            
            default: next_state = WL;
        endcase
    end

    // Output logic
    assign walk_left = (state == WL);
    assign walk_right = (state == WR);
    assign aaah = (state == FL || state == FR);
    assign digging = (state == DG);

endmodule