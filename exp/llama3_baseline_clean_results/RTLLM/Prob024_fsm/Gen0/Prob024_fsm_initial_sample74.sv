module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// Enumerate states
enum logic [2:0] {
    S0,  // Initial state
    S1,  // Received '1'
    S2,  // Received '0' after '1'
    S3,  // Received '0' after '0'
    S4,  // Received '1' after '0', '0'
    S5   // Received '1' after '1', '0', '0'
} state, next_state;

// Synchronous reset
always @ (posedge CLK) begin
    if (RST) begin
        state <= S0;
        MATCH <= 0;
    end else begin
        state <= next_state;
    end
end

// State transition logic
always @ (*) begin
    case (state)
        S0: begin
            if (IN) next_state = S1;
            else next_state = S0;
            MATCH = 0;
        end
        S1: begin
            if (~IN) next_state = S2;
            else next_state = S1;
            MATCH = 0;
        end
        S2: begin
            if (~IN) next_state = S3;
            else next_state = S1;
            MATCH = 0;
        end
        S3: begin
            if (IN) next_state = S4;
            else next_state = S2;
            MATCH = 0;
        end
        S4: begin
            if (IN) next_state = S5;
            else next_state = S0;
            MATCH = 0;
        end
        S5: begin
            MATCH = 1;
            if (IN) next_state = S1;
            else next_state = S0;
        end
    endcase
end

endmodule