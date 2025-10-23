module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // One-hot state encoding: 8 states (S0..S6, Err)
    localparam S0  = 8'b0000_0001; // 0 consecutive ones
    localparam S1  = 8'b0000_0010; // 1 consecutive one
    localparam S2  = 8'b0000_0100; // 2 consecutive ones
    localparam S3  = 8'b0000_1000; // 3 consecutive ones
    localparam S4  = 8'b0001_0000; // 4 consecutive ones
    localparam S5  = 8'b0010_0000; // 5 consecutive ones
    localparam S6  = 8'b0100_0000; // 6 consecutive ones
    localparam ERR = 8'b1000_0000; // error state: 7 or more ones

    reg [7:0] state, next_state;

    // Next state logic
    always @(*) begin
        case (state)
            S0:  next_state = in ? S1 : S0;
            S1:  next_state = in ? S2 : S0;
            S2:  next_state = in ? S3 : S0;
            S3:  next_state = in ? S4 : S0;
            S4:  next_state = in ? S5 : S0;
            S5:  next_state = in ? S6 : S0;
            S6:  next_state = in ? ERR : S0;
            ERR: next_state = in ? ERR : S0;
            default: next_state = S0; // safe default
        endcase
    end

    // Outputs depend only on state (Moore) and previous input condition:
    // disc: zero after 5 ones -> detect when prev state is S5 and input=0
    // flag: zero after 6 ones -> detect when prev state is S6 and input=0
    // err: in ERR state

    // Since outputs must be asserted one cycle after detection,
    // outputs are driven by previous state and previous input.

    // To implement this, we register the inputs and states to detect the conditions,
    // then assert outputs synchronously on next cycle.

    reg in_d;           // delayed input (previous cycle)
    reg [7:0] state_d;  // delayed state (previous cycle)

    always @(posedge clk) begin
        if (reset) begin
            state   <= S0;
            state_d <= S0;
            in_d    <= 1'b0;
            disc    <= 1'b0;
            flag    <= 1'b0;
            err     <= 1'b0;
        end else begin
            state <= next_state;
            state_d <= state;
            in_d <= in;

            // disc asserted if previous state was S5 and previous input was 0
            disc <= (state_d == S5) && (in_d == 1'b0);

            // flag asserted if previous state was S6 and previous input was 0
            flag <= (state_d == S6) && (in_d == 1'b0);

            // err asserted if current state is ERR
            err <= (next_state == ERR);
        end
    end

endmodule