module TopModule (
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

    // Binary encoded FSM states
    localparam S0 = 3'd0; // no match yet
    localparam S1 = 3'd1; // matched '1'
    localparam S2 = 3'd2; // matched '11'
    localparam S3 = 3'd3; // matched '110'
    localparam S4 = 3'd4; // matched '1101' (final detected state)

    reg [2:0] state;
    wire [2:0] next_state;

    // Combinational next-state logic as continuous assignment
    assign next_state = (state == S0) ? (data ? S1 : S0) :
                        (state == S1) ? (data ? S2 : S0) :
                        (state == S2) ? (data ? S2 : S3) :
                        (state == S3) ? (data ? S4 : S0) :
                        S4; // sticky final state

    // State register with synchronous reset (active-high)
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Moore output combinationally derived from current state
    assign start_shifting = (state == S4);

endmodule