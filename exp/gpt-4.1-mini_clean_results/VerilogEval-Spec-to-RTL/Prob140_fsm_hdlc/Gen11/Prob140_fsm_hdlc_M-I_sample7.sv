module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // States 0 to 6 represent count of consecutive ones (0 to 6)
    // Count 7 or more consecutive ones is error condition (signaled by output, state saturates at 6+)
    reg [2:0] state, next_state;

    // Next-state logic (combinational)
    // State = count of consecutive ones so far (0 to 6)
    always @(*) begin
        case (state)
            3'd0: next_state = in ? 3'd1 : 3'd0;
            3'd1: next_state = in ? 3'd2 : 3'd0;
            3'd2: next_state = in ? 3'd3 : 3'd0;
            3'd3: next_state = in ? 3'd4 : 3'd0;
            3'd4: next_state = in ? 3'd5 : 3'd0;
            3'd5: next_state = in ? 3'd6 : 3'd0;
            3'd6: next_state = in ? 3'd6 : 3'd0; // Saturate at 6 for error detection
            default: next_state = 3'd0;
        endcase
    end

    // Outputs registered on clock; outputs asserted for one cycle after condition
    // Conditions detected based on current state and input (in previous cycle)
    // disc: detected when exactly 5 consecutive ones followed by a 0 (transition S5 + in=0)
    // flag: detected when exactly 6 consecutive ones followed by a 0 (transition S6 + in=0)
    // err: detected when 7 or more consecutive ones (state=6 and in=1)

    always @(posedge clk) begin
        if (reset) begin
            state <= 3'd0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            // Update state
            state <= next_state;

            // Generate outputs one cycle after detection conditions:
            // Use previous state and current input to generate outputs on this cycle
            disc <= (state == 3'd5) && (in == 1'b0);
            flag <= (state == 3'd6) && (in == 1'b0);
            err  <= (state == 3'd6) && (in == 1'b1);
        end
    end

endmodule