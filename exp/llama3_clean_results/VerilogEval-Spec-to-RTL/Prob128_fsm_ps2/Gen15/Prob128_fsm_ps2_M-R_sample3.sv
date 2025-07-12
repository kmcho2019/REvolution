module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

// Define states for the FSM
logic [1:0] state;

always_ff @(posedge clk) begin
    if(reset) begin
        state <= 2'b00; // Reset state to SEARCH
    end else begin
        case(state)
            2'b00: // SEARCH
                if(in[3]) begin
                    state <= 2'b01; // Transition to BYTE1
                end
            2'b01: // BYTE1
                state <= 2'b10; // Transition to BYTE2
            2'b10: // BYTE2
                state <= 2'b00; // Transition back to SEARCH
            default: state <= 2'b00; // Default to SEARCH
        endcase
    end
end

// Assert 'done' when transitioning from BYTE2 to SEARCH
assign done = (state == 2'b10) && in[3] == 0;
// However, this might not be accurate due to the missing check for the next state.
// A better approach is to directly infer the state transitions and output based on the current state and input.
// Thus, the above line is adjusted to accurately reflect the logic:
assign done = (state == 2'b10);

endmodule