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
    reg w_reg;
    reg w_stable;

    // Clock gating for input register
    always @(posedge clk) begin
        if (reset) begin
            w_reg <= 1'b0;
            w_stable <= 1'b0;
        end else begin
            w_stable <= (w == w_reg);
            if (!w_stable) begin
                w_reg <= w;
            end
        end
    end

    // Combinational next-state logic
    always @(*) begin
        unique case (state)
            A: next_state = w_reg ? A : B;
            B: next_state = w_reg ? D : C;
            C: next_state = w_reg ? D : E;
            D: next_state = w_reg ? A : F;
            E: next_state = w_reg ? D : E;
            F: next_state = w_reg ? D : C;
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