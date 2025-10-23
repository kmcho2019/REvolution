module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // State encoding (3-bit)
    typedef enum reg [2:0] {
        S0 = 3'd0,
        S1 = 3'd1,
        S2 = 3'd2,
        S3 = 3'd3,
        S4 = 3'd4,
        S5 = 3'd5
    } state_t;

    reg [2:0] state, next_state;

    // Combinational next state logic
    always @(*) begin
        case(state)
            S0: next_state = (IN == 1'b1) ? S1 : S0;
            S1: next_state = (IN == 1'b0) ? S2 : S1;
            S2: next_state = (IN == 1'b0) ? S3 : S1;
            S3: next_state = (IN == 1'b1) ? S4 : S0;
            S4: next_state = (IN == 1'b1) ? S5 : S2;
            S5: next_state = (IN == 1'b0) ? S2 : S1;
            default: next_state = S0;
        endcase
    end

    // Sequential state update and Mealy output
    always @(posedge CLK) begin
        if (RST) begin
            state <= S0;
            MATCH <= 1'b0;
        end else begin
            state <= next_state;
            // MATCH is asserted on detecting last bit of sequence (state S4 and IN=1)
            MATCH <= (state == S4) && (IN == 1'b1);
        end
    end

endmodule