module TopModule (
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

    // State encoding (binary)
    localparam S0 = 3'd0; // no match
    localparam S1 = 3'd1; // matched '1'
    localparam S2 = 3'd2; // matched "11"
    localparam S3 = 3'd3; // matched "110"
    localparam S4 = 3'd4; // matched "1101" final state - latch start_shifting

    reg [2:0] state, next_state;

    // Next state combinational logic
    always @(*) begin
        case (state)
            S0: next_state = data ? S1 : S0;
            S1: next_state = data ? S2 : S0;
            S2: next_state = data ? S2 : S3;
            S3: next_state = data ? S4 : S0;
            S4: next_state = S4; // Remain in final detected state
            default: next_state = S0;
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Output register driven by state
    always @(posedge clk) begin
        if (reset)
            start_shifting <= 1'b0;
        else if (state == S4)
            start_shifting <= 1'b1;
        else
            start_shifting <= start_shifting; // hold once asserted
    end

endmodule