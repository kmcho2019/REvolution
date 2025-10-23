module TopModule (
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

    // State encoding - binary encoded FSM with localparam for clarity
    localparam S0 = 3'd0; // no match yet
    localparam S1 = 3'd1; // matched '1'
    localparam S2 = 3'd2; // matched '11'
    localparam S3 = 3'd3; // matched '110' or final detected state sticky (merged S4)

    reg [2:0] state, next_state;

    // Combinational next-state logic - simplified with merged final state
    always @(*) begin
        case (state)
            S0: next_state = data ? S1 : S0;
            S1: next_state = data ? S2 : S0;
            S2: next_state = data ? S2 : S3;
            S3: next_state = S3; // sticky final detected state
            default: next_state = S0;
        endcase
    end

    // Sequential state update with synchronous reset (active high)
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            // Output registered, sticky start_shifting asserted when in S3 or beyond
            start_shifting <= (next_state == S3) ? 1'b1 : start_shifting;
        end
    end

endmodule