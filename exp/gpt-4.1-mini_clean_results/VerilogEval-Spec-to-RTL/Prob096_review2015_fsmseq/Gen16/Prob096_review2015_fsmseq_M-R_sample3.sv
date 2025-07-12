module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

    // One-hot state encoding
    localparam [4:0]
        S0 = 5'b00001, // no bits matched
        S1 = 5'b00010, // matched '1'
        S2 = 5'b00100, // matched "11"
        S3 = 5'b01000, // matched "110"
        S4 = 5'b10000; // matched "1101" (final detected state)

    reg [4:0] state, next_state;

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state combinational logic
    always @(*) begin
        // Default to safe state to cover invalid states
        next_state = S0;

        if (state == S0) begin
            next_state = data ? S1 : S0;
        end else if (state == S1) begin
            next_state = data ? S2 : S0;
        end else if (state == S2) begin
            next_state = data ? S2 : S3;
        end else if (state == S3) begin
            next_state = data ? S4 : S0;
        end else if (state == S4) begin
            // Hold detected state indefinitely
            next_state = S4;
        end
    end

    // Output asserted when FSM in detected state S4
    assign start_shifting = (state == S4);

endmodule