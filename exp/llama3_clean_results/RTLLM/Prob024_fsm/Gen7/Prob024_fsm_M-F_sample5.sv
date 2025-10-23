module fsm(
    input logic IN,
    input logic CLK,
    input logic RST,
    output logic MATCH
);

// One-hot encoding for the states
logic [3:0] state, next_state;

// Asynchronous reset
always @(posedge RST) begin
    state <= 4'b0001; // Reset to IDLE state
    MATCH <= 1'b0;
end

// Synchronous logic
always_ff @(posedge CLK) begin
    if (RST) begin
        state <= 4'b0001; // Reset to IDLE state
        MATCH <= 1'b0;
    end else begin
        state <= next_state;
    end
end

// Combinational logic
always_comb begin
    next_state = state; // Default: stay in the current state
    MATCH = 1'b0; // Default: no match

    case (state)
        4'b0001: // IDLE
            if (IN) next_state = 4'b0010; // Transition to S1 on input 1
        4'b0010: // S1
            if (~IN) next_state = 4'b0100; // Transition to S2 on input 0
        4'b0100: // S2
            if (~IN) next_state = 4'b0100; // Stay in S2 on input 0
            else next_state = 4'b1000; // Transition to S3 on input 1
        4'b1000: // S3
            if (IN) begin // On input 1, match and revert to IDLE
                next_state = 4'b0001;
                MATCH = 1'b1;
            end else next_state = 4'b0001; // Revert to IDLE on any other input
    endcase
end

endmodule