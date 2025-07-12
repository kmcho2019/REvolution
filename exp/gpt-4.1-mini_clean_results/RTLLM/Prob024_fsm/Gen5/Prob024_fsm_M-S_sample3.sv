module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

// State encoding for how many bits matched:
// 0: no match yet
// 1: matched '1'
// 2: matched '10'
// 3: matched '100'
// 4: matched '1001' (waiting for last '1' to complete)
localparam [2:0]
    S0 = 3'd0,
    S1 = 3'd1,
    S2 = 3'd2,
    S3 = 3'd3,
    S4 = 3'd4;

reg [2:0] state, next_state;

always @(*) begin
    case(state)
        S0: next_state = (IN) ? S1 : S0;
        S1: next_state = (IN) ? S1 : S2;
        S2: next_state = (IN) ? S1 : S3;
        S3: next_state = (IN) ? S4 : S0;
        S4: next_state = (IN) ? S1 : S2;
        default: next_state = S0;
    endcase
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;
        MATCH <= 1'b0;
    end else begin
        state <= next_state;
        // MATCH asserted when completing sequence at last '1' input (i.e., at S4 and IN=1)
        MATCH <= (next_state == S4) && IN;
    end
end

endmodule