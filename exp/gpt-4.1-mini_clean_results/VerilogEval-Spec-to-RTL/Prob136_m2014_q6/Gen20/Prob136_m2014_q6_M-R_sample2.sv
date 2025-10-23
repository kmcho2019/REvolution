module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot state encoding
    localparam [5:0]
        A = 6'b000001,
        B = 6'b000010,
        C = 6'b000100,
        D = 6'b001000,
        E = 6'b010000,
        F = 6'b100000;

    reg [5:0] state, next_state;

    // Next state combinational logic using one-hot encoding and continuous assign pattern
    wire w_inv = ~w;

    always @(*) begin
        case (state)
            A: next_state = w_inv ? B : A;
            B: next_state = w_inv ? C : D;
            C: next_state = w_inv ? E : D;
            D: next_state = w_inv ? F : A;
            E: next_state = w_inv ? E : D;
            F: next_state = w_inv ? C : D;
            default: next_state = A;
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output z is asserted in states E or F
    assign z = state[4] | state[5];

endmodule