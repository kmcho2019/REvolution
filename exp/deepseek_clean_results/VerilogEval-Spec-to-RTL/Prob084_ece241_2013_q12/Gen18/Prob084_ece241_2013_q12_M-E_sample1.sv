module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);
    reg [7:0] memory;
    wire [2:0] sel = {A, B, C};

    // Circular shift register with parallel load capability
    always @(posedge clk) begin
        if (enable) begin
            memory <= {memory[6:0], S};  // Standard shift operation
        end
    end

    // Hierarchical 8:1 mux using 2:1 muxes in three levels
    wire level1_0 = sel[0] ? memory[1] : memory[0];
    wire level1_1 = sel[0] ? memory[3] : memory[2];
    wire level1_2 = sel[0] ? memory[5] : memory[4];
    wire level1_3 = sel[0] ? memory[7] : memory[6];

    wire level2_0 = sel[1] ? level1_2 : level1_0;
    wire level2_1 = sel[1] ? level1_3 : level1_1;

    assign Z = sel[2] ? level2_1 : level2_0;
endmodule