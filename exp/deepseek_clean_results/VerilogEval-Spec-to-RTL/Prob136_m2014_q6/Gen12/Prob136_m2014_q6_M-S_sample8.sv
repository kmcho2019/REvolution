module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Gray-coded states
    localparam A=0, B=1, C=3, D=2, E=6, F=4;
    reg [2:0] state;

    always @(posedge clk) begin
        if (reset) state <= A;
        else case (state)
            A: state <= w ? A : B;
            B: state <= w ? D : C;
            C: state <= w ? D : E;
            D: state <= w ? A : F;
            E: state <= w ? D : E;
            F: state <= w ? D : C;
        endcase
    end

    assign z = state[2];  // E and F states have MSB set

endmodule