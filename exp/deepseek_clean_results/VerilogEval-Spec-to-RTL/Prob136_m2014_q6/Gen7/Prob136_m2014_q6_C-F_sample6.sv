module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Optimized Gray-coded state encoding
    parameter [2:0] A = 3'b000,
                    B = 3'b001,
                    D = 3'b011,
                    C = 3'b010,
                    F = 3'b110,
                    E = 3'b100;

    reg [2:0] state;

    // State transition logic
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else begin
            case (state)
                A: state <= w ? A : B;
                B: state <= w ? D : C;
                C: state <= w ? D : E;
                D: state <= w ? A : F;
                E: state <= w ? D : E;
                F: state <= w ? D : C;
                default: state <= A;
            endcase
        end
    end

    // Output is 1 for states E (100) and F (110) - detect when state[2] is 1
    assign z = state[2];

endmodule