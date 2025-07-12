module counter_12 (
    input wire rst_n,         // Active low reset
    input wire clk,           // Clock signal
    input wire valid_count,   // Enable counting
    output reg [3:0] out      // 4-bit counter output
);

// One-hot encoded state representation (12 states)
reg [11:0] state;

// Terminal state detection (state 11)
wire terminal_state = state[11];

// Next state logic
wire [11:0] next_state = (!rst_n) ? 12'b000000000001 :  // Reset to state 0
                        (valid_count && !terminal_state) ? {state[10:0], 1'b0} : // Shift left
                        (valid_count && terminal_state) ? 12'b000000000001 : // Wrap around
                        state; // Hold current state

// State to output conversion
always @(*) begin
    case (1'b1)
        state[0]: out = 4'b0000;
        state[1]: out = 4'b0001;
        state[2]: out = 4'b0010;
        state[3]: out = 4'b0011;
        state[4]: out = 4'b0100;
        state[5]: out = 4'b0101;
        state[6]: out = 4'b0110;
        state[7]: out = 4'b0111;
        state[8]: out = 4'b1000;
        state[9]: out = 4'b1001;
        state[10]: out = 4'b1010;
        state[11]: out = 4'b1011;
        default: out = 4'b0000;
    endcase
end

// State register
always @(posedge clk) begin
    state <= next_state;
end

endmodule