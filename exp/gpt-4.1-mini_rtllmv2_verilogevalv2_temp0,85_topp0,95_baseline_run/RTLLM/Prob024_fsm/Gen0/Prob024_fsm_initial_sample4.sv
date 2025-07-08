module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // State encoding
    localparam S0 = 3'd0; // initial state, no bits matched
    localparam S1 = 3'd1; // matched '1'
    localparam S2 = 3'd2; // matched '10'
    localparam S3 = 3'd3; // matched '100'
    localparam S4 = 3'd4; // matched '1001'

    reg [2:0] state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        case (state)
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
                    next_state = S1; // stay in S1 if input is 1 (sequence can start again)
            end
            S2: begin
                if (IN == 1'b0)
                    next_state = S3;
                else if (IN == 1'b1)
                    next_state = S1; // restart sequence on '1'
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
                if (IN == 1'b1)
                    next_state = S1; // After a match, next could start with '1'
                else if (IN == 1'b0)
                    next_state = S2;
                else
                    next_state = S0;
            end
            default: next_state = S0;
        endcase
    end

    // State and output logic (sequential)
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= S0;
            MATCH <= 1'b0;
        end else begin
            state <= next_state;

            // Mealy output logic: MATCH=1 when current input completes "10011"
            // The sequence ends on state S4 with input IN=1 (which means next_state=S1)
            // So MATCH=1 when state is S4 and IN=1 (triggering next_state = S1)
            // Because this is Mealy, MATCH depends on current state and input
            if (state == S4 && IN == 1'b1)
                MATCH <= 1'b1;
            else
                MATCH <= 1'b0;
        end
    end

endmodule