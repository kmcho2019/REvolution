module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [5:0] state; // One-hot encoding for states
reg [5:0] next_state; // Next state

// Combinational logic for next state
assign next_state[0] = (~RST) & (state[0] & ~IN) | (RST & ~IN); // S0
assign next_state[1] = (~RST) & (state[0] & IN); // S1
assign next_state[2] = (~RST) & (state[1] & ~IN); // S2
assign next_state[3] = (~RST) & (state[2] & ~IN); // S3
assign next_state[4] = (~RST) & (state[3] & IN); // S4
assign next_state[5] = (~RST) & (state[4] & IN); // S5

// Sequential logic for state update and output
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        state <= 6'b100000; // Reset to S0
        MATCH <= 1'b0;
    end else begin
        state <= next_state;
        MATCH <= state[5] & IN; // Set MATCH to 1 when in S5 and IN is 1
    end
end

endmodule