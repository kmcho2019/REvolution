module fsm(
    input       IN,
    input       CLK,
    input       RST,
    output      MATCH
);

    // State encoding using parameters for better synthesis compatibility
    localparam [2:0]
        S0 = 3'b000,  // no match yet
        S1 = 3'b001,  // matched '1'
        S2 = 3'b010,  // matched '10'
        S3 = 3'b011,  // matched '100'
        S4 = 3'b100;  // matched '1001'

    reg [2:0] current_state, next_state;

    // Next state logic (combinational)
    always @(*) begin
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
                    next_state = S1; // stay in S1 if '1'
            end

            S2: begin
                if (IN == 1'b0)
                    next_state = S3;
                else // IN == 1
                    next_state = S1;
            end

            S3: begin
                if (IN == 1'b1)
                    next_state = S4;
                else
                    next_state = S0;
            end

            S4: begin
                if (IN == 1'b1)
                    next_state = S1; // sequence complete, restart from S1 due to overlap
                else // IN == 0
                    next_state = S2; // overlap partial match
            end

            default: next_state = S0;
        endcase
    end

    // State register update (synchronous with asynchronous reset)
    always @(posedge CLK or posedge RST) begin
        if (RST)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    // Mealy output logic (combinational): MATCH=1 when in S4 and input IN=1 (i.e., sequence completed)
    assign MATCH = (current_state == S4) && (IN == 1'b1);

endmodule