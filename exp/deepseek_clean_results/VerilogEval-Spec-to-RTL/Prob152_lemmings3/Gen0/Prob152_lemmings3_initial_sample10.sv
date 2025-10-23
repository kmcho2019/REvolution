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

    // Define states
    parameter WL = 3'b000;  // Walking left
    parameter WR = 3'b001;  // Walking right
    parameter FL = 3'b010;  // Falling left
    parameter FR = 3'b011;  // Falling right
    parameter DL = 3'b100;  // Digging left
    parameter DR = 3'b101;  // Digging right

    reg [2:0] state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            WL: begin
                if (~ground) next_state = FL;
                else if (dig) next_state = DL;
                else if (bump_left) next_state = WR;
                else next_state = WL;
            end
            WR: begin
                if (~ground) next_state = FR;
                else if (dig) next_state = DR;
                else if (bump_right) next_state = WL;
                else next_state = WR;
            end
            FL: next_state = ground ? WL : FL;
            FR: next_state = ground ? WR : FR;
            DL: next_state = ground ? DL : FL;
            DR: next_state = ground ? DR : FR;
            default: next_state = WL;
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk, posedge areset) begin
        if (areset) state <= WL;
        else state <= next_state;
    end

    // Output logic
    assign walk_left = (state == WL);
    assign walk_right = (state == WR);
    assign aaah = (state == FL || state == FR);
    assign digging = (state == DL || state == DR);

endmodule