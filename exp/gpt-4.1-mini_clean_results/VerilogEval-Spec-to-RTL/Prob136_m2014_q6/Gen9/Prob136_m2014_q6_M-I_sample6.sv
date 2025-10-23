module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

    // One-hot encoding for states (6 states -> 6 bits)
    localparam [5:0]
        A = 6'b000001,
        B = 6'b000010,
        C = 6'b000100,
        D = 6'b001000,
        E = 6'b010000,
        F = 6'b100000;

    reg [5:0] state, next_state;

    // Sequential state update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Combinational next state and output logic
    always @(*) begin
        // Default next state to current to avoid latches
        next_state = state;
        z = 1'b0;

        case (1'b1)  // one-hot decoding
            state[A]: begin
                next_state = (w == 1'b0) ? B : A;
                z = 1'b0;
            end
            state[B]: begin
                next_state = (w == 1'b0) ? C : D;
                z = 1'b0;
            end
            state[C]: begin
                next_state = (w == 1'b0) ? E : D;
                z = 1'b0;
            end
            state[D]: begin
                next_state = (w == 1'b0) ? F : A;
                z = 1'b0;
            end
            state[E]: begin
                next_state = (w == 1'b0) ? E : D;
                z = 1'b1;
            end
            state[F]: begin
                next_state = (w == 1'b0) ? C : D;
                z = 1'b1;
            end
            default: begin
                next_state = A;
                z = 1'b0;
            end
        endcase
    end

endmodule