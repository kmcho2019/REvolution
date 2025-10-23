module TopModule (
    input  clk,
    input  enable,
    input  S,
    input  A,
    input  B,
    input  C,
    output Z
);

    reg [7:0] Q;

    // 8-bit shift register: shift right with S into Q[0] on posedge clk if enable
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S};
        end
    end

    // Level 0 muxes: 4 2-to-1 muxes controlled by C
    wire mux0_0 = C ? Q[1] : Q[0];
    wire mux0_1 = C ? Q[3] : Q[2];
    wire mux0_2 = C ? Q[5] : Q[4];
    wire mux0_3 = C ? Q[7] : Q[6];

    // Level 1 muxes: 2 2-to-1 muxes controlled by B
    wire mux1_0 = B ? mux0_1 : mux0_0;
    wire mux1_1 = B ? mux0_3 : mux0_2;

    // Level 2 mux: final 2-to-1 mux controlled by A
    assign Z = A ? mux1_1 : mux1_0;

endmodule