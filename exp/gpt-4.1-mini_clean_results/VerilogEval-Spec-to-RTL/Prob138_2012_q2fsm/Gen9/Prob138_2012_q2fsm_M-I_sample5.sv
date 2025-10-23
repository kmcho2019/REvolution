module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

    // Binary encoding for states (3 bits)
    localparam A = 3'b000,
               B = 3'b001,
               C = 3'b010,
               D = 3'b011,
               E = 3'b100,
               F = 3'b101;

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
            default: next_state = A; // Safety default
        endcase
    end

    // Output logic: z=1 when in states E or F, else 0
    // E = 3'b100, F = 3'b101
    always @(*) begin
        z = (state == E) || (state == F);
    end

endmodule