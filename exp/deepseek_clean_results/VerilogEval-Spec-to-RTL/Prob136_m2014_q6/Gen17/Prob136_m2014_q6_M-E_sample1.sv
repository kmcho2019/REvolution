module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot state encoding
    // [0]:A, [1]:B, [2]:C, [3]:D, [4]:E, [5]:F
    reg [5:0] state;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= 6'b000001; // Reset to state A
        end else begin
            case (1'b1) // Synthesis will optimize this to parallel logic
                state[0]: state <= w ? 6'b000001 : 6'b000010; // A->A or A->B
                state[1]: state <= w ? 6'b001000 : 6'b000100; // B->D or B->C
                state[2]: state <= w ? 6'b001000 : 6'b010000; // C->D or C->E
                state[3]: state <= w ? 6'b000001 : 6'b100000; // D->A or D->F
                state[4]: state <= w ? 6'b001000 : 6'b010000; // E->D or E->E
                state[5]: state <= w ? 6'b001000 : 6'b000100; // F->D or F->C
                default:  state <= 6'b000001; // Fault recovery
            endcase
        end
    end

    // Output is high when in states E or F
    assign z = state[4] | state[5];

endmodule