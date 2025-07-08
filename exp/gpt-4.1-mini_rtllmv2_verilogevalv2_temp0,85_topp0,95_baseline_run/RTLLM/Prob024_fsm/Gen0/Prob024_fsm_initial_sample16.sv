module fsm (
    input        IN,
    input        CLK,
    input        RST,
    output reg   MATCH
);

    // State encoding for sequence "1 0 0 1 1"
    typedef enum reg [2:0] {
        S0 = 3'd0, // initial state, no match yet
        S1 = 3'd1, // matched "1"
        S2 = 3'd2, // matched "10"
        S3 = 3'd3, // matched "100"
        S4 = 3'd4  // matched "1001"
    } state_t;

    state_t current_state, next_state;

    // Next state logic and output logic (Mealy)
    always @(*) begin
        MATCH = 1'b0;
        case (current_state)
            S0: begin
                if (IN == 1'b1)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                if (IN == 1'b0)
                    next_state = S2;
                else
                    next_state = S1; // stay in S1 if input is 1, still matching prefix "1"
            end
            S2: begin
                if (IN == 1'b0)
                    next_state = S3;
                else if (IN == 1'b1)
                    next_state = S1; // restart from S1 since input 1 can start the sequence
                else
                    next_state = S0;
            end
            S3: begin
                if (IN == 1'b1)
                    next_state = S4;
                else if (IN == 1'b0)
                    next_state = S0;
                else
                    next_state = S0;
            end
            S4: begin
                if (IN == 1'b1) begin
                    next_state = S1;
                    MATCH = 1'b1; // sequence matched at this input
                end else if (IN == 1'b0) begin
                    next_state = S2;
                end else begin
                    next_state = S0;
                end
            end
            default: begin
                next_state = S0;
                MATCH = 1'b0;
            end
        endcase
    end

    // State register update on clock and synchronous reset
    always @(posedge CLK) begin
        if (RST) begin
            current_state <= S0;
            MATCH <= 1'b0;
        end else begin
            current_state <= next_state;
            // MATCH is combinational output, but Mealy output must be synchronized here to output at same clk cycle
            // To ensure MATCH asserted at the clock cycle where sequence ends, we register it here
            if (current_state == S4 && IN == 1'b1)
                MATCH <= 1'b1;
            else
                MATCH <= 1'b0;
        end
    end

endmodule