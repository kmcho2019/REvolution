module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);
    // Individual DFFs for shift register
    reg [7:0] Q;
    
    // Shift register with distributed muxing
    always @(posedge clk) begin
        Q[0] <= enable ? S : Q[0];
        Q[1] <= enable ? Q[0] : Q[1];
        Q[2] <= enable ? Q[1] : Q[2];
        Q[3] <= enable ? Q[2] : Q[3];
        Q[4] <= enable ? Q[3] : Q[4];
        Q[5] <= enable ? Q[4] : Q[5];
        Q[6] <= enable ? Q[5] : Q[6];
        Q[7] <= enable ? Q[6] : Q[7];
    end

    // Hierarchical mux structure
    wire mux_level1_0 = A ? (B ? Q[3] : Q[2]) : (B ? Q[1] : Q[0]);
    wire mux_level1_1 = A ? (B ? Q[7] : Q[6]) : (B ? Q[5] : Q[4]);
    wire mux_level2 = A ? mux_level1_1 : mux_level1_0;
    assign Z = C ? mux_level2 : mux_level1_0;
endmodule