module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

    reg [7:0] Q;

    // 8-bit shift register with synchronous active-high enable
    // Shift right on each clock, shifting in S at LSB (Q[0])
    always @(posedge clk) begin
        if (enable)
            Q <= {Q[6:0], S};
    end

    // Hierarchical 8-to-1 mux using 2-to-1 muxes controlled by C, B, then A
    wire mux0 = C ? Q[1] : Q[0];
    wire mux1 = C ? Q[3] : Q[2];
    wire mux2 = C ? Q[5] : Q[4];
    wire mux3 = C ? Q[7] : Q[6];

    wire mux4 = B ? mux1 : mux0;
    wire mux5 = B ? mux3 : mux2;

    assign Z = A ? mux5 : mux4;

endmodule