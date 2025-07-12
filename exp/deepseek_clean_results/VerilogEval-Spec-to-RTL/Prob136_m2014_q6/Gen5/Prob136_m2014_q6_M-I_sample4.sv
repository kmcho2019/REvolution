module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // One-hot state encoding
    parameter [5:0] A = 6'b000001,
                    B = 6'b000010,
                    C = 6'b000100,
                    D = 6'b001000,
                    E = 6'b010000,
                    F = 6'b100000;

    reg [5:0] state;
    wire clk_gated;
    reg enable_clock;

    // Clock gating for power optimization
    assign clk_gated = clk & enable_clock;

    // State transition logic
    always @(posedge clk_gated or posedge reset) begin
        if (reset) begin
            state <= A;
            enable_clock <= 1'b1;
        end
        else begin
            case (1'b1) // synthesis parallel_case
                state[A]: begin
                    state <= w ? A : B;
                    enable_clock <= ~w; // Gate clock if staying in A
                end
                state[B]: begin
                    state <= w ? D : C;
                    enable_clock <= 1'b1;
                end
                state[C]: begin
                    state <= w ? D : E;
                    enable_clock <= ~w; // Gate clock if going to E
                end
                state[D]: begin
                    state <= w ? A : F;
                    enable_clock <= 1'b1;
                end
                state[E]: begin
                    state <= w ? D : E;
                    enable_clock <= ~w; // Gate clock if staying in E
                end
                state[F]: begin
                    state <= w ? D : C;
                    enable_clock <= 1'b1;
                end
            endcase
        end
    end

    // Output logic - registered for better timing
    always @(posedge clk) begin
        if (reset)
            z <= 1'b0;
        else
            z <= state[E] | state[F]; // Explicit output condition
    end

endmodule