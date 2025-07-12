module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // State encoding one-hot for 6 states:
    // S0: no match (initial)
    // S1: matched '1'
    // S2: matched '10'
    // S3: matched '100'
    // S4: matched '1001'
    // S5: matched '10011' (final matched state)
    localparam S0 = 6'b000001;
    localparam S1 = 6'b000010;
    localparam S2 = 6'b000100;
    localparam S3 = 6'b001000;
    localparam S4 = 6'b010000;
    localparam S5 = 6'b100000;

    reg [5:0] state, next_state;

    // Next state logic combinational (one-hot)
    always @(*) begin
        case (state)
            S0: begin
                if (IN)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                if (IN)
                    next_state = S1;  // repeated '1' stays here
                else
                    next_state = S2;  // '0' after '1'
            end
            S2: begin
                if (IN)
                    next_state = S1;  // if '1' after '10', restart matching from S1
                else
                    next_state = S3;  // another '0' after '10'
            end
            S3: begin
                if (IN)
                    next_state = S4;  // '1' after '100'
                else
                    next_state = S0;  // reset if input is '0'
            end
            S4: begin
                if (IN)
                    next_state = S5;  // '1' after '1001' completes sequence
                else
                    next_state = S2;  // '0' after '1001' means partial restart from '10'
            end
            S5: begin
                // After full match, stay matched or restart based on input for loop detection
                if (IN)
                    next_state = S1;  // as sequence starts with '1', loop detection
                else
                    next_state = S2;  // input '0' leads to matched '10'
            end
            default: next_state = S0;
        endcase
    end

    // Synchronous state update and MATCH output update
    // MATCH is '1' at the clock cycle where sequence "10011" is matched (state S5)
    always @(posedge CLK) begin
        if (RST) begin
            state <= S0;
            MATCH <= 1'b0;
        end else begin
            state <= next_state;
            MATCH <= (state == S4) && (IN == 1'b1); // Mealy output: MATCH when current state is S4 and IN=1 next moves to S5
        end
    end

endmodule