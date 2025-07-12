module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

    // One-hot state encoding
    localparam A = 6'b000001,
               B = 6'b000010,
               C = 6'b000100,
               D = 6'b001000,
               E = 6'b010000,
               F = 6'b100000;

    reg [5:0] state, next_state;

    // Sequential logic: state flip-flops with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Combinational next-state logic using continuous assignment
    // Define next state bits independently and combine them
    wire next_A, next_B, next_C, next_D, next_E, next_F;

    assign next_A = (state == D && w == 0);
    assign next_B = (state == A && w == 1);
    assign next_C = (state == B && w == 1) || (state == F && w == 1);
    assign next_D = (state == B && w == 0) || (state == C && w == 0) || (state == E && w == 0) || (state == F && w == 0);
    assign next_E = (state == C && w == 1) || (state == E && w == 1);
    assign next_F = (state == D && w == 1);

    assign next_state = {next_F, next_E, next_D, next_C, next_B, next_A};

    // Output logic: z = 1 when in state E or F
    assign z = state[4] | state[5];

endmodule