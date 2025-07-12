module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // Using 3 bits to represent states 0 to 7
wire [2:0] nextState;

// Output logic
always @(posedge clk) begin
    if (reset) begin
        disc <= 0;
        flag <= 0;
        err <= 0;
    end else begin
        case (state)
            5: disc <= 1; // State 5 means previous 5 inputs were 1, so we need to discard the next 0.
            6: flag <= 1; // State 6 means previous 6 inputs were 1, so we have a potential flag.
            7: err <= 1; // State 7 means 7 or more consecutive 1s, error condition.
            default: begin
                disc <= 0;
                flag <= 0;
                err <= 0;
            end
        endcase
    end
end

// Next state logic
always @(*) begin
    case (state)
        0: nextState = (in) ? 3'b001 : 3'b000; // State 0: If input is 1, go to State 1; otherwise, stay in State 0.
        1: nextState = (in) ? 3'b010 : 3'b000; // State 1: If input is 1, go to State 2; otherwise, go back to State 0.
        2: nextState = (in) ? 3'b011 : 3'b000; // State 2: If input is 1, go to State 3; otherwise, go back to State 0.
        3: nextState = (in) ? 3'b100 : 3'b000; // State 3: If input is 1, go to State 4; otherwise, go back to State 0.
        4: nextState = (in) ? 3'b101 : 3'b000; // State 4: If input is 1, go to State 5; otherwise, go back to State 0.
        5: nextState = (in) ? 3'b110 : 3'b100; // State 5: If input is 1, go to State 6; if 0, go to State 4 because we discard this 0.
        6: nextState = (in) ? 3'b111 : 3'b100; // State 6: If input is 1, go to State 7; if 0, go back to State 4 because we found a flag.
        7: nextState = (in) ? 3'b111 : 3'b000; // State 7: If input is 1, stay in State 7 (error condition); if 0, go back to State 0.
        default: nextState = 3'b000;
    endcase
end

// State register
always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000;
    end else begin
        state <= nextState;
    end
end

endmodule