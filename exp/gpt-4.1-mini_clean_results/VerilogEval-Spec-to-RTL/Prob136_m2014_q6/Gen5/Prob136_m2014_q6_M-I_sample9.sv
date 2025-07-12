module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

    // One-hot state encoding: six flip-flops
    // State bits: A,B,C,D,E,F
    reg A, B, C, D, E, F;
    wire A_next, B_next, C_next, D_next, E_next, F_next;

    // Next-state logic (combinational)
    assign A_next = reset ? 1'b1 :
                    (A & w) | (D & w);
    assign B_next = reset ? 1'b0 :
                    (A & ~w);
    assign C_next = reset ? 1'b0 :
                    (B & ~w) | (F & ~w);
    assign D_next = reset ? 1'b0 :
                    (B & w) | (C & w) | (E & w) | (F & w);
    assign E_next = reset ? 1'b0 :
                    (C & ~w) | (E & ~w);
    assign F_next = reset ? 1'b0 :
                    (D & ~w);

    // Sequential state update
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            A <= 1'b1;
            B <= 1'b0;
            C <= 1'b0;
            D <= 1'b0;
            E <= 1'b0;
            F <= 1'b0;
        end else begin
            A <= A_next;
            B <= B_next;
            C <= C_next;
            D <= D_next;
            E <= E_next;
            F <= F_next;
        end
    end

    // Output logic (combinational)
    always @(*) begin
        z = E | F;
    end

endmodule