module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

reg [1:0] state;
reg [1:0] nextState;

parameter walking_left = 2'b00;
parameter walking_right = 2'b01;
parameter falling_left = 2'b10;
parameter falling_right = 2'b11;

always @(posedge clk or posedge areset)
begin
    if (areset)
    begin
        state <= walking_left;
    end
    else
    begin
        state <= nextState;
    end
end

always @(*)
begin
    case(state)
        walking_left:
        begin
            if (!ground)
            begin
                nextState = falling_left;
            end
            else if (bump_left)
            begin
                nextState = walking_right;
            end
            else if (bump_right)
            begin
                nextState = walking_left;
            end
            else
            begin
                nextState = walking_left;
            end
        end
        walking_right:
        begin
            if (!ground)
            begin
                nextState = falling_right;
            end
            else if (bump_left)
            begin
                nextState = walking_right;
            end
            else if (bump_right)
            begin
                nextState = walking_left;
            end
            else
            begin
                nextState = walking_right;
            end
        end
        falling_left:
        begin
            if (ground)
            begin
                nextState = walking_left;
            end
            else
            begin
                nextState = falling_left;
            end
        end
        falling_right:
        begin
            if (ground)
            begin
                nextState = walking_right;
            end
            else
            begin
                nextState = falling_right;
            end
        end
    endcase
end

always @(*)
begin
    case(state)
        walking_left:
        begin
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
        end
        walking_right:
        begin
            walk_left = 0;
            walk_right = 1;
            aaah = 0;
        end
        falling_left:
        begin
            walk_left = 0;
            walk_right = 0;
            aaah = 1;
        end
        falling_right:
        begin
            walk_left = 0;
            walk_right = 0;
            aaah = 1;
        end
    endcase
end

endmodule