module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

    // State encoding
    localparam A = 3'd0,
               B = 3'd1,
               C = 3'd2,
               D = 3'd3,
               E = 3'd4,
               F = 3'd5;

    reg [2:0] state, next_state;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Next state logic using if-else
    always @(*) begin
        if (state == A)
            next_state = w ? B : A;
        else if (state == B)
            next_state = w ? C : D;
        else if (state == C)
            next_state = w ? E : D;
        else if (state == D)
            next_state = w ? F : A;
        else if (state == E)
            next_state = w ? E : D;
        else if (state == F)
            next_state = w ? C : D;
        else
            next_state = A;
    end

    // Output logic: z=1 only in state E
    assign z = (state == E);

endmodule