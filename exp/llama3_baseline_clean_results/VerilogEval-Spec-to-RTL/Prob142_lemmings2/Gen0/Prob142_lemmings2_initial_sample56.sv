module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output walk_left,
    output walk_right,
    output aaah
);

// Define the states
parameter WL = 2'b00;
parameter WR = 2'b01;
parameter F = 2'b10;

// Declare the state register
reg [1:0] state;
reg [1:0] nextState;

// Declare the output signals
reg walk_left_reg;
reg walk_right_reg;
reg aaah_reg;

// Output logic
always @(*)
begin
    walk_left_reg = (state == WL);
    walk_right_reg = (state == WR);
    aaah_reg = (state == F);
end

// State transition logic
always @(posedge clk or posedge areset)
begin
    if (areset)
    begin
        state <= WL;
    end
    else
    begin
        if (~ground)
        begin
            state <= F;
        end
        else if (ground && state == F)
        begin
            // Transition back to previous walking direction
            if (bump_left && bump_right)
            begin
                // No change in direction when both bumps occur
                state <= (nextState == WL)? WL : WR;
            end
            else if (bump_left)
            begin
                state <= WR;
            end
            else if (bump_right)
            begin
                state <= WL;
            end
            else
            begin
                // No bumps, transition back to previous walking direction
                state <= nextState;
            end
        end
        else
        begin
            // Normal state transitions
            if (bump_left && bump_right)
            begin
                // Switch direction when both bumps occur
                state <= (state == WL)? WR : WL;
            end
            else if (bump_left)
            begin
                state <= WR;
            end
            else if (bump_right)
            begin
                state <= WL;
            end
            else
            begin
                // No bumps, stay in the same state
                state <= state;
            end
        end
    end
end

// Combinational logic to store the next state
always @(*)
begin
    nextState = state;
    if (state == WL)
    begin
        if (bump_left)
        begin
            nextState = WR;
        end
        else if (bump_right)
        begin
            nextState = WL;
        end
    end
    else if (state == WR)
    begin
        if (bump_left)
        begin
            nextState = WR;
        end
        else if (bump_right)
        begin
            nextState = WL;
        end
    end
end

// Continuous assignment for outputs
assign walk_left = walk_left_reg;
assign walk_right = walk_right_reg;
assign aaah = aaah_reg;

endmodule