module fsm (
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// State encoding
parameter S0 = 3'b000;
parameter S1 = 3'b001;
parameter S2 = 3'b010;
parameter S3 = 3'b011;
parameter S4 = 3'b100;
parameter S5 = 3'b101;

reg [2:0] current_state, next_state;

// State register update (sequential)
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= S0;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic (combinational)
always @(*) begin
    case (current_state)
        S0: next_state = IN ? S1 : S0;
        S1: next_state = IN ? S1 : S2;
        S2: next_state = IN ? S1 : S3;
        S3: next_state = IN ? S4 : S0;
        S4: next_state = IN ? S5 : S2;
        S5: next_state = IN ? S1 : S2;
        default: next_state = S0;
    endcase
end

// Output logic (combinational, Mealy style)
always @(*) begin
    MATCH = (current_state == S4) && IN;
end

endmodule