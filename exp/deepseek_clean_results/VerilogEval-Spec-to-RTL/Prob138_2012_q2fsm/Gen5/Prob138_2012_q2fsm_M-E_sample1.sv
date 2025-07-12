module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot state encoding with output embedded in bit 6
    // [5:0] = F E D C B A
    // z = state[5] | state[4] (E or F)
    parameter [5:0] A = 6'b000001;
    parameter [5:0] B = 6'b000010;
    parameter [5:0] C = 6'b000100;
    parameter [5:0] D = 6'b001000;
    parameter [5:0] E = 6'b010000;  // z=1
    parameter [5:0] F = 6'b100000;  // z=1

    reg [5:0] state;

    // Combined state transition and register logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
        end
        else begin
            case (1'b1)  // Synthesis will optimize this to parallel checks
                state[0]: state <= w ? B : A;        // A
                state[1]: state <= w ? C : D;        // B
                state[2]: state <= w ? E : D;        // C
                state[3]: state <= w ? F : A;        // D
                state[4]: state <= w ? E : D;        // E
                state[5]: state <= w ? C : D;        // F
                default: state <= A;
            endcase
        end
    end

    // Output is simply the OR of E and F bits
    assign z = state[5] | state[4];

endmodule