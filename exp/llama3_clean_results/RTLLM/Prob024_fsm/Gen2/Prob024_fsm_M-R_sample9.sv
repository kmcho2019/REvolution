module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [2:0] state; // 3 bits can represent 8 states, but we'll use fewer
reg [2:0] nextState; // Next state logic

// Define states
parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100, S5 = 3'b101;

// Combinational logic for next state and MATCH
always @(*) begin
    case(state)
        S0: nextState = (IN == 1'b1) ? S1 : S0;
        S1: nextState = (IN == 1'b0) ? S2 : S1;
        S2: nextState = (IN == 1'b0) ? S3 : S1;
        S3: nextState = (IN == 1'b1) ? S4 : S3;
        S4: nextState = (IN == 1'b1) ? S5 : S2;
        S5: nextState = (IN == 1'b1) ? S5 : S2;
        default: nextState = S0;
    endcase
    MATCH = (state == S5 && IN == 1'b1) ? 1'b1 : 1'b0;
end

// Sequential logic for state update
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        state <= S0;
    end else begin
        state <= nextState;
    end
end

endmodule