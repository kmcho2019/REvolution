module fsm(
    input       IN,
    input       CLK,
    input       RST,
    output reg  MATCH
);

    // State encoding (one-hot style)
    localparam S0 = 5'b00001; // no match yet
    localparam S1 = 5'b00010; // matched '1'
    localparam S2 = 5'b00100; // matched '10'
    localparam S3 = 5'b01000; // matched '100'
    localparam S4 = 5'b10000; // matched '1001'

    reg [4:0] state, next_state;

    // Next state combinational logic
    always @(*) begin
        case(state)
            S0: next_state = (IN == 1'b1) ? S1 : S0;
            S1: next_state = (IN == 1'b0) ? S2 : S1;
            S2: next_state = (IN == 1'b0) ? S3 : S1; // if IN=1, restart pattern from S1
            S3: next_state = (IN == 1'b1) ? S4 : S0;
            S4: next_state = (IN == 1'b1) ? S1 : S2; // loop back for overlapping detection
            default: next_state = S0;
        endcase
    end

    // Sequential logic: update state and MATCH output
    // MATCH asserted when current state is S4 and IN=1 (i.e. at detecting last '1' of "10011")
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= S0;
            MATCH <= 1'b0;
        end else begin
            state <= next_state;
            MATCH <= (state == S4 && IN == 1'b1) ? 1'b1 : 1'b0;
        end
    end

endmodule