module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Gray-coded states
    localparam A = 3'b000, B = 3'b001, C = 3'b011,
               D = 3'b010, E = 3'b110, F = 3'b100;

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

    // Output is MSB of state (1 for E/F)
    assign z = state[2];

endmodule