module fsm(
    input IN,  // Input signal to the FSM
    input CLK,  // Clock signal
    input RST,  // Reset signal
    output reg MATCH  // Output signal indicating a match condition
);

reg [2:0] state;  // Current state of the FSM

// Define states
localparam S0 = 3'b000,  // Initial state
           S1 = 3'b001,  // '1' detected
           S2 = 3'b010,  // '10' detected
           S3 = 3'b011,  // '100' detected
           S4 = 3'b100,  // '1001' detected
           S5 = 3'b101;  // '10011' detected

always @(*) begin
    case(state)
        S0: begin
            if (IN) begin
                state = S1;
            end else begin
                state = S0;
            end
            MATCH = 0;
        end
        S1: begin
            if (~IN) begin
                state = S2;
            end else begin
                state = S1;
            end
            MATCH = 0;
        end
        S2: begin
            if (~IN) begin
                state = S3;
            end else begin
                state = S1;
            end
            MATCH = 0;
        end
        S3: begin
            if (IN) begin
                state = S4;
            end else begin
                state = S2;
            end
            MATCH = 0;
        end
        S4: begin
            if (IN) begin
                state = S5;
            end else begin
                state = S1;
            end
            MATCH = 0;
        end
        S5: begin
            MATCH = IN;
            if (IN) begin
                state = S5;
            end else begin
                state = S1;
            end
        end
        default: begin
            state = S0;
            MATCH = 0;
        end
    endcase
end

always @(posedge RST or posedge CLK) begin
    if (RST) begin
        state <= S0;
        MATCH <= 0;
    end else begin
        // No action needed here, combinational logic handles state transitions
    end
end

endmodule