module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Simple binary state encoding
    parameter [2:0] A = 0,
                    B = 1,
                    C = 2,
                    D = 3,
                    E = 4,
                    F = 5;

    reg [2:0] state;

    always @(posedge clk) begin
        if (reset)
            state <= A;
        else case (state)
            A: state <= w ? A : B;
            B: state <= w ? D : C;
            C: state <= w ? D : E;
            D: state <= w ? A : F;
            E: state <= w ? D : E;
            F: state <= w ? D : C;
        endcase
    end

    assign z = state[2];  // E and F have bit 2 set

endmodule