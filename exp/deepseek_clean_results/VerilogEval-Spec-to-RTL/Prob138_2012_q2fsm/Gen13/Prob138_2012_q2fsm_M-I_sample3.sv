module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot state encoding
    parameter [5:0] 
        A = 6'b000001,
        B = 6'b000010,
        C = 6'b000100,
        D = 6'b001000,
        E = 6'b010000,
        F = 6'b100000;

    reg [5:0] state;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
        end else begin
            case (1'b1) // synthesis parallel_case
                state[0]: state <= w ? B : A;       // A
                state[1]: state <= w ? C : D;       // B
                state[2]: state <= w ? E : D;       // C
                state[3]: state <= w ? F : A;       // D
                state[4]: state <= w ? E : D;       // E
                state[5]: state <= w ? C : D;       // F
            endcase
        end
    end

    // Output is high for states E or F (bits 4 or 5)
    assign z = state[4] | state[5];

endmodule