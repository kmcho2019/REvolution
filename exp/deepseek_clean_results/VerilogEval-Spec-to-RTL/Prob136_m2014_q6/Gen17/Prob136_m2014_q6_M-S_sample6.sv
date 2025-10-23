module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Gray-coded states (E and F have z=1)
    reg [2:0] state;
    localparam A = 3'b000, B = 3'b001, C = 3'b011,
               D = 3'b010, E = 3'b110, F = 3'b100;

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

    // Output is 1 for states E (110) and F (100)
    assign z = state[2];

endmodule