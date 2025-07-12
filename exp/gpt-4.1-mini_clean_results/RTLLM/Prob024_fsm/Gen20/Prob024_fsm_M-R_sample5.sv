module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // Binary-encoded states (3 bits sufficient for 5 states)
    localparam [2:0]
        S0 = 3'b000, // initial state
        S1 = 3'b001, // matched '1'
        S2 = 3'b010, // matched '10'
        S3 = 3'b011, // matched '100'
        S4 = 3'b100; // matched '1001'

    reg [2:0] state, next_state;

    // Next state logic combinational using assign
    wire [2:0] next_state_w;
    assign next_state_w = (state == S0) ? (IN ? S1 : S0) :
                          (state == S1) ? (IN ? S1 : S2) :
                          (state == S2) ? (IN ? S1 : S3) :
                          (state == S3) ? (IN ? S4 : S0) :
                          (state == S4) ? (IN ? S1 : S2) :
                          S0;

    // MATCH is a Mealy output, combinationally asserted when current state is S4 and IN=1
    assign MATCH = (state == S4) && IN;

    // State register with synchronous reset and non-blocking assignments
    always @(posedge CLK) begin
        if (RST)
            state <= S0;
        else
            state <= next_state_w;
    end

endmodule