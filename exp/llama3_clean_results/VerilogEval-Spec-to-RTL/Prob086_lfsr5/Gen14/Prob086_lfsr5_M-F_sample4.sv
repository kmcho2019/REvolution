module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state; // Current state of the LFSR

// Combinational logic for calculating the next state
wire next_state_4 = state[4];
wire next_state_3 = state[3] ^ state[0];
wire next_state_2 = state[2] ^ state[0];
wire next_state_1 = state[1];
wire next_state_0 = state[0];

// Sequential logic for updating the state
always @(posedge clk) begin
    if (reset) begin
        state <= 5'b00001; // Set the LFSR output to 1
    end else begin
        state[4] <= next_state_4;
        state[3] <= next_state_3;
        state[2] <= next_state_2;
        state[1] <= next_state_1;
        state[0] <= next_state_0;
    end
end

// Assign the output q to the current state
assign q = state;

endmodule