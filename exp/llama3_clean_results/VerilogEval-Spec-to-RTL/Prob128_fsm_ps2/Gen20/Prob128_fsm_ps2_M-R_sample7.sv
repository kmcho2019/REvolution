module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

// Define states for the FSM
logic [1:0] state, next_state;

// Initialize state to SEARCH
always_ff @(posedge clk) begin
    if(reset) begin
        state <= 2'b00; // SEARCH state
    end
    else begin
        state <= next_state;
    end
end

// Combinational logic for next state
assign next_state = (state == 2'b00 && in[3]) ? 2'b01 : // Transition to BYTE1
                   (state == 2'b01) ? 2'b10 : // Transition to BYTE2
                   (state == 2'b10) ? 2'b00 : // Transition back to SEARCH
                   state; // Stay in current state

// Assert 'done' when in BYTE2 state
assign done = state == 2'b10;

endmodule