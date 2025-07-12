module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Optimized Gray-coded state encoding
    parameter [2:0] A = 3'b000,
                    B = 3'b001,
                    C = 3'b011,
                    D = 3'b010,
                    E = 3'b110,
                    F = 3'b100;

    reg [2:0] state, next_state;

    // Combinational next-state logic
    always @(*) begin
        unique case (state)
            A: next_state = w ? A : B;
            B: next_state = w ? D : C;
            C: next_state = w ? D : E;
            D: next_state = w ? A : F;
            E: next_state = w ? D : E;
            F: next_state = w ? D : C;
        endcase
    end

    // Sequential state register
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Direct output assignment from state bit
    assign z = state[2];

endmodule