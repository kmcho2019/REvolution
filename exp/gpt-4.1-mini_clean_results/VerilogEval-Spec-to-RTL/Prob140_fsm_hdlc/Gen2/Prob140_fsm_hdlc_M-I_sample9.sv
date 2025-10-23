module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // State encoding
    localparam [2:0]
        S0 = 3'd0,
        S1 = 3'd1,
        S2 = 3'd2,
        S3 = 3'd3,
        S4 = 3'd4,
        S5 = 3'd5,
        S6 = 3'd6,
        S7 = 3'd7; // error state (7 or more 1s)

    reg [2:0] state, next_state;
    reg [2:0] prev_state;

    // Next state logic
    always @(*) begin
        case (state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? S6 : S0;
            S6: next_state = in ? S7 : S0;
            S7: next_state = in ? S7 : S0;
            default: next_state = S0;
        endcase
    end

    // State register update and outputs
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            prev_state <= S0;
            disc <= 1'b0;
            flag <= 1'b0;
            err <= 1'b0;
        end else begin
            prev_state <= state;
            state <= next_state;

            // Detect disc: transition from S5 to S0 means input=0 after 5 ones
            disc <= (prev_state == S5) && (next_state == S0);
            // Detect flag: transition from S6 to S0 means input=0 after 6 ones
            flag <= (prev_state == S6) && (next_state == S0);
            // Error if in S7 (7 or more ones)
            err <= (next_state == S7);
        end
    end

endmodule