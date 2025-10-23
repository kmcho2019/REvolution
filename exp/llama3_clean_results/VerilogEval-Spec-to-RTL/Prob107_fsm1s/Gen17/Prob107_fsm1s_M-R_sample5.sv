module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

parameter STATE_B = 0, STATE_A = 1;
reg [0:0] state; // Current state
reg [0:0] next_state; // Next state
reg out_comb; // Combinational output

// Define the next state logic
always @(*) begin
    case(state)
        STATE_B: next_state = (in == 0)? STATE_A : STATE_B;
        STATE_A: next_state = (in == 0)? STATE_B : STATE_A;
        default: next_state = STATE_B; // Default to state B
    endcase
end

// Define the output logic
assign out_comb = (state == STATE_B)? 1'b1 : 1'b0;

// Sequential logic
always @(posedge clk) begin
    if(reset) begin
        state <= STATE_B; // Reset state is B
        out <= 1'b1; // Reset output is 1
    end else begin
        state <= next_state;
        out <= out_comb;
    end
end

endmodule