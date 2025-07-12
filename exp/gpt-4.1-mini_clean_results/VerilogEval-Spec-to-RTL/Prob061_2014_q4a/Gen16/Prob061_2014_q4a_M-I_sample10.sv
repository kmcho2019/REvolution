module TopModule (
    input        clk,
    input        w,
    input        R,
    input        E,
    input        L,
    output reg   Q
);

    wire next_Q;
    wire clk_en;

    // Enable clock only if loading or shifting
    assign clk_en = L | E;

    // Combinational logic to select next state of Q
    assign next_Q = L ? R : (E ? w : Q);

    // Gated clock generation (simple AND gating, 
    // consider technology-specific clock gating primitives in ASIC/FPGA)
    wire gated_clk = clk & clk_en;

    // Sequential register update on gated clock edge
    always @(posedge gated_clk) begin
        Q <= next_Q;
    end

endmodule