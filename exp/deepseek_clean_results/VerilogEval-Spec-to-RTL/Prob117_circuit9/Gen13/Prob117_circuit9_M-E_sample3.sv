module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

// State definitions
localparam [2:0] S4 = 3'd4,
                 S5 = 3'd5,
                 S6 = 3'd6,
                 S0 = 3'd0,
                 S1 = 3'd1;

reg [2:0] current_state, next_state;

// State transition logic
always @(posedge clk) begin
    current_state <= next_state;
end

// Next state logic
always @(*) begin
    case (current_state)
        S4: next_state = a ? S4 : S5;
        S5: next_state = a ? S4 : S6;
        S6: next_state = a ? S4 : S0;
        S0: next_state = a ? S4 : S1;
        S1: next_state = a ? S4 : S4; // After S1, it would normally go to S2 but waveform shows wrap to S4
        default: next_state = S4;
    endcase
end

// Output logic (Moore machine - outputs depend only on state)
always @(*) begin
    q = current_state;
end

endmodule