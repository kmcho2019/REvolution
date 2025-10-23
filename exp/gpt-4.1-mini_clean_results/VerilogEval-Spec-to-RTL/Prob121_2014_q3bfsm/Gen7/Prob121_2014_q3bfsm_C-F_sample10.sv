module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    // State encoding using localparams for readability and maintainability
    localparam S0 = 3'b000,
               S1 = 3'b001,
               S2 = 3'b010,
               S3 = 3'b011,
               S4 = 3'b100;

    reg [2:0] state, next_state;

    // Next state logic: combinational, blocking assignments
    always @(*) begin
        case (state)
            S0: next_state = (x) ? S1 : S0;
            S1: next_state = (x) ? S4 : S1;
            S2: next_state = (x) ? S1 : S2;
            S3: next_state = (x) ? S2 : S1;
            S4: next_state = (x) ? S4 : S3;
            default: next_state = S0; // safe default state
        endcase
    end

    // State register with synchronous active-high reset, non-blocking assignment
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Output logic: combinational block sensitive only to state
    always @(*) begin
        case(state)
            S3, S4: z = 1'b1;
            default: z = 1'b0;
        endcase
    end

endmodule