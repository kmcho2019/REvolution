module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // State encoding for six states (3 bits)
    localparam [2:0]
        S0 = 3'd0,
        S1 = 3'd1,
        S2 = 3'd2,
        S3 = 3'd3,
        S4 = 3'd4,
        S5 = 3'd5;

    reg [2:0] state, next_state;
    reg in_d; // Delayed input for detecting input changes

    // Detect input or state change to generate clock enable
    wire clk_en = (IN != in_d) || (state != next_state);

    // Next state logic using case statement (combinational)
    always @(*) begin
        case (state)
            S0: next_state = (IN) ? S1 : S0;
            S1: next_state = (IN) ? S1 : S2;
            S2: next_state = (IN) ? S1 : S3;
            S3: next_state = (IN) ? S4 : S0;
            S4: next_state = (IN) ? S5 : S2;
            S5: next_state = (IN) ? S1 : S2;
            default: next_state = S0;
        endcase
    end

    // Sequential logic: state update with synchronous reset and clock enable
    always @(posedge CLK) begin
        if (RST) begin
            state <= S0;
            in_d <= 1'b0;
        end else begin
            in_d <= IN;
            if (clk_en)
                state <= next_state;
        end
    end

    // MATCH output as Mealy output: asserted when in state S4 and IN=1
    assign MATCH = (state == S4) && IN;

endmodule