module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output          done
);

// Define states for the FSM using one-hot encoding
logic [3:0] state, next_state;

always_comb begin
    next_state = state;
    case(state)
        4'b0001: begin // IDLE state
            if(in[3]) next_state = 4'b0010; // Transition to BYTE1 if in[3] = 1
        end
        4'b0010: begin // BYTE1 state
            next_state = 4'b0100; // Proceed to BYTE2
        end
        4'b0100: begin // BYTE2 state
            next_state = 4'b1000; // Proceed to BYTE3
        end
        4'b1000: begin // BYTE3 state
            next_state = 4'b0001; // Reset to IDLE after receiving the third byte
        end
    endcase
end

always_ff @(posedge clk) begin
    if(reset) state <= 4'b0001; // Reset to IDLE on reset
    else state <= next_state;
end

// Assert 'done' in the cycle after receiving the third byte
logic done_sync;
always_ff @(posedge clk) begin
    if(reset) done_sync <= 1'b0;
    else if(state == 4'b1000) done_sync <= 1'b1;
    else done_sync <= 1'b0;
end

assign done = done_sync;

endmodule