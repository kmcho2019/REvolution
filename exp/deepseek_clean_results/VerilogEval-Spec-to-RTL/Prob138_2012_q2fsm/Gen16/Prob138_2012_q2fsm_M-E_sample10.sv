module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot state encoding with output z as dedicated bit
    localparam [6:0] A = 7'b0000001,
                     B = 7'b0000010,
                     C = 7'b0000100,
                     D = 7'b0001000,
                     E = 7'b1010000,  // z=1
                     F = 7'b0100000;   // z=1

    reg [6:0] state;
    wire clk_gated;

    // Parallel next-state computation for all possible current states
    wire [6:0] next_A = (w) ? B : A;
    wire [6:0] next_B = (w) ? C : D;
    wire [6:0] next_C = (w) ? E : D;
    wire [6:0] next_D = (w) ? F : A;
    wire [6:0] next_E = (w) ? E : D;
    wire [6:0] next_F = (w) ? C : D;

    // Clock gating for stable states (E and F)
    assign clk_gated = clk & ~((state == E & w) | (state == F & w));

    // Priority encoder for next state selection
    always @(*) begin
        case (1'b1)
            state[0]: state = next_A;
            state[1]: state = next_B;
            state[2]: state = next_C;
            state[3]: state = next_D;
            state[4]: state = next_E;
            state[5]: state = next_F;
            default:  state = A;
        endcase
    end

    // State register with synchronous reset and clock gating
    always @(posedge clk_gated or posedge reset) begin
        if (reset) state <= A;
        else state <= next_state;
    end

    // Output z is directly encoded in state bits
    assign z = state[6] | state[5];

endmodule