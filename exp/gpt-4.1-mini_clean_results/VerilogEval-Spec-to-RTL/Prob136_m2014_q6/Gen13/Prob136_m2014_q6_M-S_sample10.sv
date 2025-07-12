module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

    // State encoding
    localparam A = 3'd0, B = 3'd1, C = 3'd2, D = 3'd3, E = 3'd4, F = 3'd5;

    reg [2:0] state, next_state;

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            A: next_state = (w == 0) ? B : A;
            B: next_state = (w == 0) ? C : D;
            C: next_state = (w == 0) ? E : D;
            D: next_state = (w == 0) ? F : A;
            E: next_state = (w == 0) ? E : D;
            F: next_state = (w == 0) ? C : D;
            default: next_state = A;
        endcase
    end

    // Output logic: z=1 in states E or F
    assign z = (state == E) || (state == F);

endmodule