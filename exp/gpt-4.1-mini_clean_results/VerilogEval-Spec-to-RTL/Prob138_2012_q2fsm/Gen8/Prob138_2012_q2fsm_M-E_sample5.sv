module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

    // State encoding using 3 bits (binary)
    localparam [2:0]
        A = 3'b000,
        B = 3'b001,
        C = 3'b010,
        D = 3'b011,
        E = 3'b100,
        F = 3'b101;

    reg [2:0] state, next_state;

    // State flip-flops with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Next-state combinational logic using case statement
    always @(*) begin
        case(state)
            A: next_state = w ? B : A;
            B: next_state = w ? C : D;
            C: next_state = w ? E : D;
            D: next_state = w ? F : A;
            E: next_state = w ? E : D;
            F: next_state = w ? C : D;
            default: next_state = A; // Handle invalid states
        endcase
    end

    // Output z asserted for states E and F
    assign z = (state == E) || (state == F);

endmodule