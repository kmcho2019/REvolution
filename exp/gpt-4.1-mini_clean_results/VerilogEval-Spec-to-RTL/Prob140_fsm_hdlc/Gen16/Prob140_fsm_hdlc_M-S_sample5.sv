module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire in,
    output wire disc,
    output wire flag,
    output wire err
);

    // State encoding: count of consecutive ones (0 to 7+)
    // S0 to S6 = counts 0 to 6 ones
    // S7 = error state (7 or more ones)
    localparam [3:0]
        S0 = 4'd0,
        S1 = 4'd1,
        S2 = 4'd2,
        S3 = 4'd3,
        S4 = 4'd4,
        S5 = 4'd5,
        S6 = 4'd6,
        S7 = 4'd7;

    reg [3:0] state, next_state;

    // Next state logic: count consecutive ones up to 7+
    always @(*) begin
        case (state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? S6 : S0;
            S6: next_state = in ? S7 : S0; // flag or error on zero later
            S7: next_state = in ? S7 : S0; // remain error until zero seen
            default: next_state = S0;
        endcase
    end

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Outputs are Moore-type, asserted for one cycle after detection
    // disc: one cycle after seeing exactly 5 ones followed by 0 => state was S5, now input=0
    // flag: one cycle after seeing exactly 6 ones followed by 0 => state was S6, now input=0
    // err: whenever state == S7 (7 or more ones)
    //
    // Since Moore output depends only on state, to produce disc/flag for one cycle after detection:
    // Use a registered version of (state, in) from previous cycle to detect patterns
    // But since we have synchronous reset and one clock delay, we assign outputs based on current state only:
    // disc = state == S5 and next input was zero => we can detect disc when state == S5 and input=0 means next state is S0,
    // so disc output occurs in state S0 immediately after disc condition, but we want Moore output on next cycle.
    //
    // Alternative approach: outputs asserted when state is S0, and previous state was S5 or S6, with input=0 last cycle
    //
    // To maintain Moore output timing, store previous state and previous input
    reg [3:0] prev_state;
    reg prev_in;

    always @(posedge clk) begin
        if (reset) begin
            prev_state <= S0;
            prev_in <= 1'b0;
        end else begin
            prev_state <= state;
            prev_in <= in;
        end
    end

    assign disc = (prev_state == S5) && (prev_in == 1'b0);
    assign flag = (prev_state == S6) && (prev_in == 1'b0);
    assign err  = (state == S7);

endmodule