module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

    // State encoding: number of matched bits in sequence "1101"
    localparam [2:0]
        S0 = 3'd0, // no bits matched
        S1 = 3'd1, // matched '1'
        S2 = 3'd2, // matched "11"
        S3 = 3'd3, // matched "110"
        S4 = 3'd4; // matched "1101" (final)

    reg [2:0] state, next_state;

    // State update on positive clock edge with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        if (state == S4) begin
            // Stay in detected state forever
            next_state = S4;
        end else begin
            case (state)
                S0: next_state = data ? S1 : S0;
                S1: next_state = data ? S2 : S0;
                S2: next_state = data ? S2 : S3;
                S3: next_state = data ? S4 : S0;
                default: next_state = S0;
            endcase
        end
    end

    // Output logic: start_shifting asserted when sequence found (state S4)
    always @(posedge clk) begin
        if (reset)
            start_shifting <= 1'b0;
        else if (state == S4)
            start_shifting <= 1'b1;
    end

endmodule