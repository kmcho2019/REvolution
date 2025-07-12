module fsm (
    input CLK,
    input RST,
    input IN,
    output MATCH
);

// One-hot state encoding
parameter IDLE    = 4'b0001;
parameter GOT1    = 4'b0010;
parameter GOT10   = 4'b0100;
parameter GOT100  = 4'b1000;

reg [3:0] current_state, next_state;

// State transition logic (parallel assignments)
always @(*) begin
    next_state = 4'b0;  // Default to IDLE if no conditions met
    
    // IDLE transitions
    if (current_state[0] && IN) next_state[1] = 1'b1;  // IDLE -> GOT1
    
    // GOT1 transitions
    if (current_state[1] && IN) next_state[1] = 1'b1;  // GOT1 -> GOT1
    if (current_state[1] && !IN) next_state[2] = 1'b1; // GOT1 -> GOT10
    
    // GOT10 transitions
    if (current_state[2] && IN) next_state[1] = 1'b1;  // GOT10 -> GOT1
    if (current_state[2] && !IN) next_state[3] = 1'b1; // GOT10 -> GOT100
    
    // GOT100 transitions
    if (current_state[3] && IN) next_state[1] = 1'b1;  // GOT100 -> GOT1
    if (current_state[3] && !IN) next_state[2] = 1'b1; // GOT100 -> GOT10
end

// State register
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Output logic - continuous assignment when in GOT100 state and IN=1
assign MATCH = (current_state == GOT100) && IN;

endmodule