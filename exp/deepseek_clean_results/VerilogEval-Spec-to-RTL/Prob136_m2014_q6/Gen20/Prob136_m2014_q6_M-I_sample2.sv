module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Gray-coded state encoding
    localparam [2:0] 
        A = 3'b000,
        B = 3'b001,
        C = 3'b011,
        D = 3'b010,
        E = 3'b110,
        F = 3'b100;

    reg [2:0] state, next_state_reg;
    reg state_unchanged;

    // Clock gating control
    wire state_change = (state != next_state_reg);
    wire gated_clk = clk & (reset | state_change);

    // Next state computation (registered)
    always @(posedge clk) begin
        if (reset) begin
            next_state_reg <= A;
            state_unchanged <= 1'b0;
        end else begin
            case (state)
                A: next_state_reg <= w ? A : B;
                B: next_state_reg <= w ? D : C;
                C: next_state_reg <= w ? D : E;
                D: next_state_reg <= w ? A : F;
                E: next_state_reg <= w ? D : E;
                F: next_state_reg <= w ? D : C;
            endcase
            state_unchanged <= (state == next_state_reg);
        end
    end

    // State transition with gated clock
    always @(posedge gated_clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state_reg;
    end

    // Output is MSB of state (E and F states)
    assign z = state[2];

endmodule