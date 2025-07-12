module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

// Define states for the FSM
logic [1:0] state;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= 2'd0; // Reset to SEARCH state
    end else begin
        case(state)
            2'd0: // SEARCH
                if (in[3]) begin
                    state <= 2'd1; // Transition to BYTE1
                end
            2'd1: // BYTE1
                state <= 2'd2; // Transition to BYTE2
            2'd2: // BYTE2
                state <= 2'd0; // Transition back to SEARCH
            default: state <= 2'd0; // Default to SEARCH state
        endcase
    end
end

// Assert 'done' when a message is fully received (at the end of BYTE2)
assign done = (state == 2'd2);
endmodule