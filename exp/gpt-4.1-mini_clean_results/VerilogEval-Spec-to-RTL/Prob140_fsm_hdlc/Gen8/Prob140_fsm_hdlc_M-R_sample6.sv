module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // State encoding for counts of consecutive ones (S0 to S6)
    typedef enum reg [2:0] {
        S0 = 3'd0, // zero consecutive ones
        S1 = 3'd1,
        S2 = 3'd2,
        S3 = 3'd3,
        S4 = 3'd4,
        S5 = 3'd5,
        S6 = 3'd6,
        S7 = 3'd7  // error state: 7 or more consecutive ones
    } state_t;

    reg [2:0] state, next_state;

    // Next-state logic: Moore FSM transitions based on current state and input
    always @(*) begin
        case (state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? S6 : S0;
            S6: next_state = in ? S7 : S0;
            S7: next_state = in ? S7 : S0; // stay in error until zero input
            default: next_state = S0;
        endcase
    end

    // Output logic depends only on current state and input (Moore FSM):
    // Outputs asserted one clock after condition occurs, so outputs depend on current state and input
    // Conditions:
    // - disc: on input 0 after state S5
    // - flag: on input 0 after state S6
    // - err : when in error state (S7)
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state;

            // Outputs asserted for exactly one cycle after condition occurs
            disc <= (state == S5 && in == 1'b0);
            flag <= (state == S6 && in == 1'b0);
            err  <= (state == S7);
        end
    end

endmodule