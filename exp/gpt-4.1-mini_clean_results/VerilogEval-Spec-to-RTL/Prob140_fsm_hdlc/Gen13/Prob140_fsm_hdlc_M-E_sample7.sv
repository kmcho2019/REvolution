module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // Define states representing consecutive ones count
    typedef enum logic [3:0] {
        S0 = 4'd0,  // no consecutive ones
        S1 = 4'd1,
        S2 = 4'd2,
        S3 = 4'd3,
        S4 = 4'd4,
        S5 = 4'd5,  // potential discard if next bit is 0
        S6 = 4'd6,  // potential flag if next bit is 0
        S7 = 4'd7   // error state (7 or more consecutive ones)
    } state_t;

    state_t state, next_state;

    // Next state combinational logic
    always @(*) begin
        case(state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? S6 : S0;
            S6: next_state = in ? S7 : S0;
            S7: next_state = in ? S7 : S0; // stay in error on 1, reset on 0
            default: next_state = S0;
        endcase
    end

    // Output logic: Moore FSM, outputs depend on current state only
    always @(*) begin
        disc = 1'b0;
        flag = 1'b0;
        err  = 1'b0;
        case(state)
            S5: disc = 1'b1; // Exactly 5 ones previously, waiting for zero to discard
            S6: flag = 1'b1; // Exactly 6 ones previously, waiting for zero to flag frame
            S7: err  = 1'b1; // 7 or more ones = error
            default: ;
        endcase
    end

    // State and output registers update on clock edge with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state;
            disc  <= disc;
            flag  <= flag;
            err   <= err;
        end
    end

endmodule