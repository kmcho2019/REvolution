module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot encoded states (6 states)
    parameter [5:0] A = 6'b000001,
                    B = 6'b000010,
                    C = 6'b000100,
                    D = 6'b001000,
                    E = 6'b010000,
                    F = 6'b100000;

    reg [5:0] state;

    // State transition logic
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else begin
            case (1'b1) // synthesis parallel_case
                state[0]: state <= w ? A : B;       // A
                state[1]: state <= w ? D : C;       // B
                state[2]: state <= w ? D : E;       // C
                state[3]: state <= w ? A : F;       // D
                state[4]: state <= w ? D : E;       // E
                state[5]: state <= w ? D : C;       // F
            endcase
        end
    end

    // Output is 1 for states E (010000) and F (100000)
    assign z = state[5] | state[4];

endmodule