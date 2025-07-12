module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

    // One-hot encoded states
    localparam [5:0]
        A = 6'b000001,
        B = 6'b000010,
        C = 6'b000100,
        D = 6'b001000,
        E = 6'b010000,
        F = 6'b100000;

    reg [5:0] state, next_state;

    // State register update
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Next-state and output logic
    always @(*) begin
        next_state = 6'b0; // default to none active

        case (state)
            A: next_state = (w == 0) ? B : A;
            B: next_state = (w == 0) ? C : D;
            C: next_state = (w == 0) ? E : D;
            D: next_state = (w == 0) ? F : A;
            E: next_state = (w == 0) ? E : D;
            F: next_state = (w == 0) ? C : D;
            default: next_state = A;
        endcase

        // Output logic: z = 1 in states E or F
        z = (state == E) || (state == F);
    end

endmodule