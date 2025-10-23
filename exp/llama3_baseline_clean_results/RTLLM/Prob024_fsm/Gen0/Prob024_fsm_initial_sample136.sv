module fsm(
    input IN,
    input CLK,
    input RST,
    output MATCH
);

reg [2:0] state; // Current state of the FSM
reg [2:0] next_state; // Next state of the FSM
reg match_reg; // Registered output of the MATCH signal

// Define states
localparam S0 = 3'b000; // Idle state
localparam S1 = 3'b001; // State after receiving the first '1'
localparam S2 = 3'b010; // State after receiving the first '0'
localparam S3 = 3'b011; // State after receiving the second '0'
localparam S4 = 3'b100; // State after receiving the first '1' in the sequence 11

always @(*) begin
    // Default next state is the current state
    next_state = state;

    case(state)
        S0: begin
            if (IN == 1) begin
                next_state = S1;
            end else begin
                next_state = S0;
            end
        end
        S1: begin
            if (IN == 0) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
        end
        S2: begin
            if (IN == 0) begin
                next_state = S3;
            end else begin
                next_state = S1;
            end
        end
        S3: begin
            if (IN == 1) begin
                next_state = S4;
            end else begin
                next_state = S0;
            end
        end
        S4: begin
            if (IN == 1) begin
                next_state = S4; // Stay in S4 as long as the input is '1'
            end else begin
                next_state = S0; // Reset to S0 if the input is not '1'
            end
        end
        default: next_state = S0;
    endcase
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;
        match_reg <= 0;
    end else begin
        state <= next_state;
        if (state == S4 && IN == 1) begin
            match_reg <= 1;
        end else begin
            match_reg <= 0;
        end
    end
end

assign MATCH = match_reg;

endmodule