module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

    // Gray code encoding for 6 states (3 bits)
    // Gray codes chosen to minimize bit toggling between typical transitions
    localparam [2:0]
        A = 3'b000,
        B = 3'b001,
        C = 3'b011,
        D = 3'b010,
        E = 3'b110,
        F = 3'b111;

    reg [2:0] state, next_state;

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            A: next_state = w ? B : A;
            B: next_state = w ? C : D;
            C: next_state = w ? E : D;
            D: next_state = w ? F : A;
            E: next_state = w ? E : D;
            F: next_state = w ? C : D;
            default: next_state = A; // Safety fallback
        endcase
    end

    // Output logic: z=1 when in states E or F, else 0
    assign z = (state == E) || (state == F);

endmodule