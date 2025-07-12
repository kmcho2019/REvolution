module counter_12 (
    input wire rst_n,          // Active low reset
    input wire clk,            // Clock
    input wire valid_count,    // Count enable
    output wire [3:0] out     // Counter output
);

// One-hot encoded states (12 states)
reg [11:0] state;

// Next state logic
wire [11:0] next_state = (!rst_n) ? 12'b000000000001 :  // Reset to state 0
                        (!valid_count) ? state :       // Hold current state
                        (state == 12'b100000000000) ? 12'b000000000001 : // Wrap from 11 to 0
                        {state[10:0], state[11]};      // Rotate left for next state

// State register update
always @(posedge clk) begin
    state <= next_state;
end

// Priority encoder for binary output
assign out = (state[0]) ? 4'd0 :
             (state[1]) ? 4'd1 :
             (state[2]) ? 4'd2 :
             (state[3]) ? 4'd3 :
             (state[4]) ? 4'd4 :
             (state[5]) ? 4'd5 :
             (state[6]) ? 4'd6 :
             (state[7]) ? 4'd7 :
             (state[8]) ? 4'd8 :
             (state[9]) ? 4'd9 :
             (state[10]) ? 4'd10 :
             4'd11;  // state[11]

endmodule