module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

    // State encoding using localparam for clarity
    localparam [2:0]
        A = 3'd0,
        B = 3'd1,
        C = 3'd2,
        D = 3'd3,
        E = 3'd4,
        F = 3'd5;

    reg [2:0] state, next_state;

    // State register update on rising clock edge with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Next state logic using combinational always with case statement for better synthesis
    always @(*) begin
        case(state)
            A: next_state = (w == 1'b0) ? B : A;
            B: next_state = (w == 1'b0) ? C : D;
            C: next_state = (w == 1'b0) ? E : D;
            D: next_state = (w == 1'b0) ? F : A;
            E: next_state = (w == 1'b0) ? E : D;
            F: next_state = (w == 1'b0) ? C : D;
            default: next_state = A; // safe default state
        endcase
    end

    // Output logic: z=1 when state is E or F
    assign z = (state == E) || (state == F);

endmodule