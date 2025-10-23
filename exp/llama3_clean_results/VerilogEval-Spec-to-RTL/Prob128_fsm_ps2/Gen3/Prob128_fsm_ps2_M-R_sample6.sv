module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output          done
);

// Define states for the FSM using binary encoding
logic [1:0] state, next_state;

always_comb begin
    next_state = state;
    case(state)
        2'b00: begin // IDLE state
            if(in[3]) next_state = 2'b01; // Transition to BYTE1 if in[3] = 1
        end
        2'b01: begin // BYTE1 state
            next_state = 2'b10; // Proceed to BYTE2
        end
        2'b10: begin // BYTE2 state
            next_state = 2'b11; // Proceed to BYTE3
        end
        2'b11: begin // BYTE3 state
            next_state = 2'b00; // Reset to IDLE after receiving the third byte
        end
    endcase
end

always_ff @(posedge clk) begin
    if(reset) state <= 2'b00; // Reset to IDLE on reset
    else state <= next_state;
end

// Assert 'done' in the cycle after receiving the third byte
assign done = (state == 2'b11);

endmodule