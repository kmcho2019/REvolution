module fsm (
    input IN,
    input CLK,
    input RST,
    output MATCH
);

// One-hot state encoding
parameter S0 = 6'b000001;
parameter S1 = 6'b000010;
parameter S2 = 6'b000100;
parameter S3 = 6'b001000;
parameter S4 = 6'b010000;
parameter S5 = 6'b100000;

reg [5:0] current_state, next_state;

// State register update (sequential)
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= S0;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic (combinational using assign)
assign next_state[0] = (~current_state[0] | IN) ? 1'b0 : 1'b1;  // S0
assign next_state[1] = (current_state[0] & IN) |                 // S0->S1
                      (current_state[1] & IN) |                  // S1->S1
                      (current_state[4] & ~IN) |                 // S4->S2
                      (current_state[5] & IN);                   // S5->S1
assign next_state[2] = (current_state[1] & ~IN) |                // S1->S2
                      (current_state[4] & ~IN) |                 // S4->S2
                      (current_state[5] & ~IN);                  // S5->S2
assign next_state[3] = current_state[2] & ~IN;                   // S2->S3
assign next_state[4] = current_state[3] & IN;                    // S3->S4
assign next_state[5] = current_state[4] & IN;                    // S4->S5

// Output logic (combinational, Mealy style)
assign MATCH = (current_state[4] & IN);  // S4 and IN=1

endmodule