module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // State represents count of consecutive ones: 0 to 6
    // Use 3 bits: 0 to 6 valid counts, 7 means error (7 or more ones)
    reg [2:0] state, next_state;

    // Outputs are registered, asserted for one cycle after condition detection (Moore)
    reg disc_d, flag_d, err_d;

    always @(*) begin
        // Default next state: stay or reset
        case(state)
            3'd0: next_state = in ? 3'd1 : 3'd0;
            3'd1: next_state = in ? 3'd2 : 3'd0;
            3'd2: next_state = in ? 3'd3 : 3'd0;
            3'd3: next_state = in ? 3'd4 : 3'd0;
            3'd4: next_state = in ? 3'd5 : 3'd0;
            3'd5: next_state = in ? 3'd6 : 3'd0; // disc condition detected here (next cycle)
            3'd6: next_state = in ? 3'd7 : 3'd0; // flag condition detected here (next cycle)
            3'd7: next_state = in ? 3'd7 : 3'd0; // error state sticky until zero
            default: next_state = 3'd0;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= 3'd0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state;

            // Outputs are asserted for one cycle after condition detection
            // Disc: when previous state was 5 and input was 0 (means next_state=0)
            //   So detect disc when state==5 and in==0 on previous cycle.
            // Flag: state==6 and in==0 previous cycle.
            // Err: when in error state (state==7).

            // We can detect disc and flag by looking at current state and input delayed by one clock.
            // But since inputs are not stored, we base outputs only on state and next_state transitions.

            // Simplify by asserting disc when current state is 0 and previous state was 5 and input zero occurred:
            // Instead, since Moore outputs depend only on current state, we delay disc and flag by one cycle.
            // So track them using separate registers that latch conditions.

            // To implement Moore outputs for disc and flag:
            // Use delayed signals that reflect the detection events from previous cycle.

            // Detect disc: previous state was 5 and input was 0
            // Detect flag: previous state was 6 and input was 0
            // Detect err: state == 7

            // Since 'state' is updated here, and inputs only available now,
            // we must store input and state from previous cycle to create outputs properly.

            // To keep it simple, register previous state and input.
        end
    end

    // Register previous state and input to generate outputs (Moore)
    reg [2:0] state_d;
    reg       in_d;

    always @(posedge clk) begin
        if (reset) begin
            state_d <= 3'd0;
            in_d    <= 1'b0;
            disc    <= 1'b0;
            flag    <= 1'b0;
            err     <= 1'b0;
        end else begin
            state_d <= state;
            in_d    <= in;

            // disc asserted one cycle after detecting 5 ones followed by zero
            disc <= (state_d == 3'd5) && (in_d == 1'b0);

            // flag asserted one cycle after detecting 6 ones followed by zero
            flag <= (state_d == 3'd6) && (in_d == 1'b0);

            // err asserted whenever state is 7 (7 or more ones)
            err <= (state == 3'd7);
        end
    end

endmodule