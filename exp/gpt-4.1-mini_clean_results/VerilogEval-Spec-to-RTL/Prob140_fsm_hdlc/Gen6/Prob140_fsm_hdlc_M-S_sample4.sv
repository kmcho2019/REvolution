module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);
    // State encoding: count of consecutive ones (0 to 7)
    // S0 = 3'd0 means zero consecutive ones (or just saw zero)
    // S1..S7 means count of consecutive ones seen
    reg [2:0] state, next_state;

    // For Moore FSM outputs, outputs depend on current state and transition from previous input
    // We need to know if last input was zero after 5 or 6 consecutive ones.
    // We implement outputs as combinational logic from current and previous state.

    // To detect disc and flag correctly, we must know if current state is S0 and previous state was S5 or S6.

    reg [2:0] prev_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 3'd0;  // Assume previous input zero at reset
            prev_state <= 3'd0;
            disc <= 1'b0;
            flag <= 1'b0;
            err <= 1'b0;
        end else begin
            prev_state <= state;
            state <= next_state;

            // Moore outputs: depend on current state and previous state for disc and flag

            // disc: asserted one cycle after zero input following 5 ones
            // means: current state == 0 and previous state == 5
            disc <= (state == 3'd0) && (prev_state == 3'd5);

            // flag: asserted one cycle after zero input following 6 ones
            // means: current state == 0 and previous state == 6
            flag <= (state == 3'd0) && (prev_state == 3'd6);

            // err: asserted whenever 7 or more consecutive ones (state == 7)
            err <= (state == 3'd7);
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            3'd0: next_state = in ? 3'd1 : 3'd0; // zero or one
            3'd1: next_state = in ? 3'd2 : 3'd0;
            3'd2: next_state = in ? 3'd3 : 3'd0;
            3'd3: next_state = in ? 3'd4 : 3'd0;
            3'd4: next_state = in ? 3'd5 : 3'd0;
            3'd5: next_state = in ? 3'd6 : 3'd0;
            3'd6: next_state = in ? 3'd7 : 3'd0;
            3'd7: next_state = in ? 3'd7 : 3'd0; // saturate at 7
            default: next_state = 3'd0;
        endcase
    end

endmodule