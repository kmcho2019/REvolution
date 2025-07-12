module fsm(
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

// State encoding using localparam for better compatibility
localparam S0 = 3'd0; // Waiting for first '1'
localparam S1 = 3'd1; // Got '1'
localparam S2 = 3'd2; // Got '10'
localparam S3 = 3'd3; // Got '100'
localparam S4 = 3'd4; // Got '1001'

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
            else // IN == 1
                next_state = S1; // stay in S1 on consecutive 1's
        end
        S2: begin
            if (IN == 1'b0)
                next_state = S3;
            else // IN == 1
                next_state = S1; // overlap detected, restart matching from first '1'
        end
        S3: begin
            if (IN == 1'b1)
                next_state = S4;
            else // IN == 0
                next_state = S0;
        end
        S4: begin
            if (IN == 1'b1)
                next_state = S1; // matched 10011, next match can overlap here
            else if (IN == 1'b0)
                next_state = S2;
            else
                next_state = S0; // default fallback
        end
        default: next_state = S0;
    endcase
end

// State register with asynchronous reset
always @(posedge CLK or posedge RST) begin
    if (RST)
        state <= S0;
    else
        state <= next_state;
end

// MATCH output logic, registered for glitch-free output
// MATCH = 1 only when current state is S4 and input IN==1,
// indicating sequence '10011' has just completed on current clock cycle
always @(posedge CLK or posedge RST) begin
    if (RST)
        MATCH <= 1'b0;
    else
        MATCH <= (state == S4) && (IN == 1'b1);
end

endmodule