module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // State encoding
    // States represent how many bits of "10011" have been matched so far
    localparam S0 = 3'd0; // no match yet
    localparam S1 = 3'd1; // matched '1'
    localparam S2 = 3'd2; // matched '10'
    localparam S3 = 3'd3; // matched '100'
    localparam S4 = 3'd4; // matched '1001'
    
    reg [2:0] state, next_state;

    // Next state logic (Mealy FSM)
    always @(*) begin
        case (state)
            S0: begin
                if (IN)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                if (!IN)
                    next_state = S2;
                else
                    next_state = S1; // Stay here on '1', no progress
            end
            S2: begin
                if (!IN)
                    next_state = S3;
                else
                    next_state = S1; // Restart detection from S1 on '1'
            end
            S3: begin
                if (IN)
                    next_state = S4;
                else
                    next_state = S0; // No partial match if input 0 here
            end
            S4: begin
                if (IN) // Final input is '1' to complete "10011"
                    next_state = S1; // Because last matched input is '1', overlap detection, jump to S1
                else
                    next_state = S2; // If '0', possible partial sequence starting with '10'
            end
            default: next_state = S0;
        endcase
    end

    // State register and output logic
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= S0;
            MATCH <= 1'b0;
        end else begin
            state <= next_state;
            // MATCH is 1 only when current input completes the sequence, i.e., at S4 with IN=1
            // Because Mealy, output depends on state and input
            if (state == S4 && IN == 1'b1)
                MATCH <= 1'b1;
            else
                MATCH <= 1'b0;
        end
    end

endmodule