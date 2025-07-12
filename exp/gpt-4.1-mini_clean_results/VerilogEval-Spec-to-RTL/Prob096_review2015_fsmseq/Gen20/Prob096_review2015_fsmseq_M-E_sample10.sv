module TopModule (
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

    // One-hot state encoding: 5 states each with one flip-flop set
    localparam
        S0 = 5'b00001, // initial state, no match
        S1 = 5'b00010, // matched '1'
        S2 = 5'b00100, // matched "11"
        S3 = 5'b01000, // matched "110"
        S4 = 5'b10000; // detected "1101" sticky state

    reg [4:0] state, next_state;

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Next-state logic combinational block
    always @(*) begin
        case (state)
            S0: next_state = data ? S1 : S0;
            S1: next_state = data ? S2 : S0;
            S2: next_state = data ? S2 : S3;
            S3: next_state = data ? S4 : S0;
            S4: next_state = S4;  // sticky detected state
            default: next_state = S0; // fallback safe state
        endcase
    end

    // Moore output: high only in detected state
    assign start_shifting = (state == S4);

endmodule