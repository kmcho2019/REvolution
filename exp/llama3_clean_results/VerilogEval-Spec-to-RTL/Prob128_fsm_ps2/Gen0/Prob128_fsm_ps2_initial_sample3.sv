module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output          done
);

// Define states for the FSM
enum logic [1:0] {
    IDLE,  // Idle state, searching for message start
    BYTE1, // Received byte 1 of the message
    BYTE2, // Received byte 2 of the message
    BYTE3  // Received byte 3 of the message, signal done
} state, next_state;

always_comb begin
    next_state = state;
    case(state)
        IDLE: begin
            if(in[3]) next_state = BYTE1;
        end
        BYTE1: next_state = BYTE2;
        BYTE2: next_state = BYTE3;
        BYTE3: next_state = IDLE;
    endcase
end

always_ff @(posedge clk) begin
    if(reset) state <= IDLE;
    else state <= next_state;
end

assign done = (state == BYTE3);

endmodule