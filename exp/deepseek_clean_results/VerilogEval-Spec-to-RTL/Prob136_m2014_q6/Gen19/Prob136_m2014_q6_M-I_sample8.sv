module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Gray-coded state encoding with explicit localparams
    localparam [2:0] 
        A = 3'b000,
        B = 3'b001,
        C = 3'b011,
        D = 3'b010,
        E = 3'b110,
        F = 3'b100;

    reg [2:0] state, next_state_reg;
    reg w_reg;
    wire state_stable = (state == E) & ~w;

    // Clock gating for state register
    wire state_clk = clk & ~state_stable;

    // Next state computation (registered)
    always @(posedge clk) begin
        if (reset) begin
            next_state_reg <= A;
            w_reg <= 0;
        end else begin
            w_reg <= w;
            case (state)
                A: next_state_reg <= w_reg ? A : B;
                B: next_state_reg <= w_reg ? D : C;
                C: next_state_reg <= w_reg ? D : E;
                D: next_state_reg <= w_reg ? A : F;
                E: next_state_reg <= w_reg ? D : E;
                F: next_state_reg <= w_reg ? D : C;
            endcase
        end
    end

    // State transition with clock gating
    always @(posedge state_clk or posedge reset) begin
        if (reset)
            state <= A;
        else
            state <= next_state_reg;
    end

    // Output is MSB of state (E and F states)
    assign z = state[2];

endmodule