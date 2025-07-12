module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

    // State encoding using 3 bits
    localparam [2:0]
        A = 3'b000,
        B = 3'b001,
        C = 3'b010,
        D = 3'b011,
        E = 3'b100,
        F = 3'b101;

    reg [2:0] state;
    wire [2:0] next_state;

    // Next state logic as combinational continuous assignments for each bit
    assign next_state[2] =  // MSB
        (state == C && w) || (state == E) || (state == F && w);

    assign next_state[1] = 
        (state == B && w) || (state == C && !w) || (state == D && w) || (state == E && !w) || (state == F && !w);

    assign next_state[0] =
        (state == B && !w) || (state == D && !w) || (state == E) || (state == F && !w);

    // State flip-flops with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output z asserted for states E and F
    assign z = (state == E) || (state == F);

endmodule