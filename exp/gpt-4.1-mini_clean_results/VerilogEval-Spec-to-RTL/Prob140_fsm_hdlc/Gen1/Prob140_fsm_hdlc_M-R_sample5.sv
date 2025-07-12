module TopModule(
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

// State encoding: count of consecutive 1s seen so far
localparam s0 = 3'd0; // 0 consecutive 1s
localparam s1 = 3'd1; // 1 consecutive 1
localparam s2 = 3'd2; // 2 consecutive 1s
localparam s3 = 3'd3; // 3 consecutive 1s
localparam s4 = 3'd4; // 4 consecutive 1s
localparam s5 = 3'd5; // 5 consecutive 1s
localparam s6 = 3'd6; // 6 consecutive 1s
localparam s7 = 3'd7; // 7 or more consecutive 1s (error)

reg [2:0] state, next_state;

// Combinational next state logic
always @(*) begin
    case (state)
        s0: next_state = in ? s1 : s0;
        s1: next_state = in ? s2 : s0;
        s2: next_state = in ? s3 : s0;
        s3: next_state = in ? s4 : s0;
        s4: next_state = in ? s5 : s0;
        s5: next_state = in ? s6 : s0;
        s6: next_state = in ? s7 : s0;
        s7: next_state = in ? s7 : s0;
        default: next_state = s0;
    endcase
end

// State register update on rising clock edge with synchronous active-high reset
always @(posedge clk) begin
    if (reset)
        state <= s0;
    else
        state <= next_state;
end

// Outputs registered and asserted one cycle after detection
always @(posedge clk) begin
    if (reset) begin
        disc <= 1'b0;
        flag <= 1'b0;
        err  <= 1'b0;
    end else begin
        // Default outputs de-asserted
        disc <= 1'b0;
        flag <= 1'b0;
        err  <= 1'b0;

        // The outputs are asserted in the cycle *after* detection.
        // Since the state transitions on in, we check the previous state and current input to detect conditions.

        case (state)
            s5: begin
                // If in==0 after 5 ones => detected "0111110" pattern last cycle, assert disc now
                if (in == 1'b0)
                    disc <= 1'b1;
            end
            s6: begin
                // If in==0 after 6 ones => detected "01111110" flag last cycle, assert flag now
                if (in == 1'b0)
                    flag <= 1'b1;
            end
            s7: begin
                // Error condition: 7 or more consecutive ones
                err <= 1'b1;
            end
            default: begin
                // no output
            end
        endcase
    end
end

endmodule