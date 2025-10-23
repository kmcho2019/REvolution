module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

// One-hot encoded state register (10 states)
reg [9:0] state;

// Next state logic (parallel implementation)
wire [9:0] next_state = slowena ? {
    state[8],  // state 9 -> state 0
    state[7],  // state 8 -> state 9
    state[6],  // state 7 -> state 8
    state[5],  // state 6 -> state 7
    state[4],  // state 5 -> state 6
    state[3],  // state 4 -> state 5
    state[2],  // state 3 -> state 4
    state[1],  // state 2 -> state 3
    state[0],  // state 1 -> state 2
    state[9]   // state 0 -> state 1
} : state;

// State to output conversion (thermometer-like coding)
wire [3:0] state_to_q = 
    (state[0]) ? 4'b0000 :
    (state[1]) ? 4'b0001 :
    (state[2]) ? 4'b0010 :
    (state[3]) ? 4'b0011 :
    (state[4]) ? 4'b0100 :
    (state[5]) ? 4'b0101 :
    (state[6]) ? 4'b0110 :
    (state[7]) ? 4'b0111 :
    (state[8]) ? 4'b1000 :
                 4'b1001;

always @(posedge clk) begin
    if (reset) begin
        state <= 10'b0000000001; // Reset to state 0
    end else begin
        state <= next_state;
    end
    q <= state_to_q;
end

endmodule