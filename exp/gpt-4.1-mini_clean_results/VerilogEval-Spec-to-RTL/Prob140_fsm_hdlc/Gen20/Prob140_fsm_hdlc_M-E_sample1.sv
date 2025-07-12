module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // Define states representing count of consecutive ones
    typedef enum logic [7:0] {
        S0 = 8'b00000001, // 0 consecutive ones
        S1 = 8'b00000010,
        S2 = 8'b00000100,
        S3 = 8'b00001000,
        S4 = 8'b00010000,
        S5 = 8'b00100000,
        S6 = 8'b01000000,
        S7 = 8'b10000000  // 7 or more consecutive ones (saturated)
    } state_t;

    state_t state, next_state;

    // State transition combinational logic
    always @(*) begin
        case(state)
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

    // Synchronous state update and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state;

            // Reset outputs
            disc <= 1'b0;
            flag <= 1'b0;
            err  <= 1'b0;

            // Output logic (Moore outputs asserted based on current state)
            // We assert outputs for one full clock cycle immediately after sequence is detected
            // The "in" used here is the previous cycle's input implicitly via the FSM state transition

            // disc: detected zero after five consecutive ones => previous state was S5 and input now 0, so current state is S0 after S5->S0
            // Instead, outputs are asserted in the states that follow input=0 from S5 or S6:
            // Because outputs are based solely on current state, and the zero bit leads to S0,
            // we can infer outputs by detecting the transition from states with consecutive ones to S0.
            // So we store previous state to detect that transition.

        end
    end

    reg state_d; // delayed signal to indicate previous input was zero after 5 or 6 ones

    // To implement outputs for one cycle after condition, we track previous state and input
    reg [7:0] prev_state;

    always @(posedge clk) begin
        if (reset) begin
            prev_state <= S0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            prev_state <= state;

            // Defaults
            disc <= 1'b0;
            flag <= 1'b0;
            err  <= 1'b0;

            // error: current state is S7 (7 or more consecutive ones)
            if (state == S7)
                err <= 1'b1;

            // disc: transition from S5 with in=0 => state moved from S5 to S0
            // flag: transition from S6 with in=0 => state moved from S6 to S0
            // Since state now is S0, and prev_state is S5 or S6, and input was zero, output disc or flag is asserted

            // However, input is only available in combinational; to have it synchronous, save previous input
            // We can save prev_in to check

            // Will add a prev_in register to track input at previous clock

        end
    end

    reg prev_in;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 1'b0;
        end else begin
            prev_in <= in;
        end
    end

    // Recompute outputs based on previous state and previous input, outputs registered synchronously
    always @(posedge clk) begin
        if (reset) begin
            disc <= 1'b0;
            flag <= 1'b0;
            err  <= 1'b0;
        end else begin
            // Reset outputs by default
            disc <= 1'b0;
            flag <= 1'b0;
            err  <= 1'b0;

            // error: state S7 means 7 or more ones, regardless of input
            if (state == S7)
                err <= 1'b1;

            // disc: prev_state==S5 and prev_in==0 (means we saw exactly 5 ones then zero)
            if ((prev_state == S5) && (prev_in == 1'b0))
                disc <= 1'b1;

            // flag: prev_state==S6 and prev_in==0 (means exactly 6 ones then zero)
            if ((prev_state == S6) && (prev_in == 1'b0))
                flag <= 1'b1;
        end
    end

endmodule