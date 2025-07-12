module TopModule (
    input  clk,
    input  reset,
    input  x,
    output z
);

    // Define states using parameter constants
    parameter S0 = 3'd0;
    parameter S1 = 3'd1;
    parameter S2 = 3'd2;
    parameter S3 = 3'd3;
    parameter S4 = 3'd4;

    reg [2:0] state, next_state;

    // Sequential logic: synchronous reset and state register update
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Combinational next-state logic
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

    // Output logic as continuous assignment: z = 1 if state is S3 or S4, else 0
    assign z = (state == S3) || (state == S4);

endmodule