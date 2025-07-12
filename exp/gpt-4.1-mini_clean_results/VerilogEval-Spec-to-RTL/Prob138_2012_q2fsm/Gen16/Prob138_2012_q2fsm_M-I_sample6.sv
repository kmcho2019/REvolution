module TopModule (
    input  clk,
    input  reset,
    input  w,
    output reg z
);

    // State encoding (3-bit binary)
    localparam [2:0]
        A = 3'b000,
        B = 3'b001,
        C = 3'b010,
        D = 3'b011,
        E = 3'b100,
        F = 3'b101;

    reg [2:0] state, next_state;

    // Next-state logic: combinational block with case statement
    always @(*) begin
        case (state)
            A: next_state = w ? B : A;               // A(0->1):B else A
            B: next_state = w ? C : D;               // B(0->1):C else D
            C: next_state = w ? E : D;               // C(0->1):E else D
            D: next_state = w ? F : A;               // D(0->1):F else A
            E: next_state = w ? E : D;               // E(1->1):E else D
            F: next_state = w ? C : D;               // F(1->1):C else D
            default: next_state = A;                 // default safe state
        endcase
    end

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output logic: z = 1 when in E or F
    always @(*) begin
        z = (state == E) || (state == F);
    end

endmodule