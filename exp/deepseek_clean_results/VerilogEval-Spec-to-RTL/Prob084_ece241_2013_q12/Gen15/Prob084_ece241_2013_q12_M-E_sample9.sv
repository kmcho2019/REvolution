module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);
    // 8-bit shift register with explicit flip-flops
    reg [7:0] Q;
    
    always @(posedge clk) begin
        if (enable) begin
            Q[7] <= Q[6];
            Q[6] <= Q[5];
            Q[5] <= Q[4];
            Q[4] <= Q[3];
            Q[3] <= Q[2];
            Q[2] <= Q[1];
            Q[1] <= Q[0];
            Q[0] <= S;
        end
    end

    // Two-level hierarchical multiplexer
    wire [1:0] mux_level1;
    
    // First level: 4x 2:1 muxes
    assign mux_level1[0] = C ? Q[1] : Q[0];
    assign mux_level1[1] = C ? Q[3] : Q[2];
    wire mux_level1_2 = C ? Q[5] : Q[4];
    wire mux_level1_3 = C ? Q[7] : Q[6];
    
    // Second level: 2x 2:1 muxes
    wire mux_level2_0 = B ? mux_level1[1] : mux_level1[0];
    wire mux_level2_1 = B ? mux_level1_3 : mux_level1_2;
    
    // Final level: 1x 2:1 mux
    assign Z = A ? mux_level2_1 : mux_level2_0;
endmodule