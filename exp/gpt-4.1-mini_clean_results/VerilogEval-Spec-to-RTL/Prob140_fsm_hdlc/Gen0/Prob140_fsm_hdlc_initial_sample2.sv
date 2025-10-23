module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

// State encoding: number of consecutive 1s seen after last 0
// 0: zero consecutive 1s (or just seen 0)
// 1..6: number of consecutive 1s counted
// 7: error state (7 or more ones)
typedef enum reg [3:0] {
    S0 = 4'd0,
    S1 = 4'd1,
    S2 = 4'd2,
    S3 = 4'd3,
    S4 = 4'd4,
    S5 = 4'd5,
    S6 = 4'd6,
    S_ERR = 4'd7
} state_t;

reg [3:0] state, next_state;

// Sequential logic: state update on clk positive edge, synchronous reset
always @(posedge clk) begin
    if (reset) begin
        state <= S0;
        // Outputs reset
        disc <= 1'b0;
        flag <= 1'b0;
        err <= 1'b0;
    end else begin
        state <= next_state;
        // Default outputs off, set in combinational logic below
        disc <= 1'b0;
        flag <= 1'b0;
        err <= 1'b0;

        // Outputs depend on state *before* transition, following Moore FSM logic
        case (state)
            S5: begin
                if (in == 1'b0)
                    disc <= 1'b1;   // 0111110: discard zero after 5 ones
            end
            S6: begin
                if (in == 1'b0)
                    flag <= 1'b1;   // 01111110: flag detected
                else // in == 1
                    err <= 1'b1;    // 7 or more ones
            end
            S_ERR: begin
                err <= 1'b1;        // stay in error, keep err asserted
            end
            default: begin
                // no output
            end
        endcase
    end
end

// Combinational logic: next state determination
always @(*) begin
    case (state)
        S0: next_state = (in == 1'b1) ? S1 : S0;
        S1: next_state = (in == 1'b1) ? S2 : S0;
        S2: next_state = (in == 1'b1) ? S3 : S0;
        S3: next_state = (in == 1'b1) ? S4 : S0;
        S4: next_state = (in == 1'b1) ? S5 : S0;
        S5: next_state = (in == 1'b1) ? S6 : S0;
        S6: next_state = (in == 1'b1) ? S_ERR : S0;
        S_ERR: next_state = S_ERR; // remain in error state
        default: next_state = S0;
    endcase
end

endmodule