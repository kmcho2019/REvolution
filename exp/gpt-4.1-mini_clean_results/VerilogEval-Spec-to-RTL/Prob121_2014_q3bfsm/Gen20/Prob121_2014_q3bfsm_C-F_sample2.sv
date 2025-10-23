module TopModule (
    input  clk,
    input  reset,
    input  x,
    output z
);

    // State encoding with localparams for clarity
    localparam S0 = 3'b000,
               S1 = 3'b001,
               S2 = 3'b010,
               S3 = 3'b011,
               S4 = 3'b100;

    reg [2:0] state, next_state;

    // Next state logic: combinational with case statement for clarity and optimization
    always @(*) begin
        case (state)
            S0: next_state = x ? S1 : S0;
            S1: next_state = x ? S4 : S1;
            S2: next_state = x ? S1 : S2;
            S3: next_state = x ? S2 : S1;
            S4: next_state = x ? S4 : S3;
            default: next_state = S0;
        endcase
    end

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Output logic optimized using combinational expression from state bits
    assign z = (state[2] & ~state[1] & ~state[0]) | (~state[2] & state[1] & state[0]);
    // This corresponds to output 1 at states S3 (011) and S4 (100)

endmodule