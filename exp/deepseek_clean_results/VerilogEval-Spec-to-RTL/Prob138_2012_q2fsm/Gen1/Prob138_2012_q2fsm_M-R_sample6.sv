module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot state encoding
    localparam [5:0] A = 6'b000001;
    localparam [5:0] B = 6'b000010;
    localparam [5:0] C = 6'b000100;
    localparam [5:0] D = 6'b001000;
    localparam [5:0] E = 6'b010000;
    localparam [5:0] F = 6'b100000;

    reg [5:0] state;

    // Combined state transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
        end else begin
            case (1'b1) // synthesis parallel_case
                state[A]: state <= w ? B : A;
                state[B]: state <= w ? C : D;
                state[C]: state <= w ? E : D;
                state[D]: state <= w ? F : A;
                state[E]: state <= w ? E : D;
                state[F]: state <= w ? C : D;
                default: state <= A;
            endcase
        end
    end

    // Output is high for states E or F (bits 4 or 5 in one-hot)
    assign z = state[4] | state[5];

endmodule