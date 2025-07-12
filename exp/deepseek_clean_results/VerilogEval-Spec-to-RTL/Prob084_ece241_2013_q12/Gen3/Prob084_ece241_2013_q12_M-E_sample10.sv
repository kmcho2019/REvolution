module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);
    reg [7:0] circular_reg;
    wire [2:0] sel = {A, B, C};
    
    // Hierarchical mux implementation
    wire [1:0] stage1 [0:3];
    wire [3:0] stage2;
    
    // Circular shift register with parallel maintain
    always @(posedge clk) begin
        if (enable) begin
            circular_reg <= {circular_reg[6:0], S}; // Shift left
        end
    end
    
    // First stage muxes (4x 2:1)
    assign stage1[0] = sel[0] ? circular_reg[1] : circular_reg[0];
    assign stage1[1] = sel[0] ? circular_reg[3] : circular_reg[2];
    assign stage1[2] = sel[0] ? circular_reg[5] : circular_reg[4];
    assign stage1[3] = sel[0] ? circular_reg[7] : circular_reg[6];
    
    // Second stage muxes (2x 2:1)
    assign stage2[1:0] = sel[1] ? stage1[1] : stage1[0];
    assign stage2[3:2] = sel[1] ? stage1[3] : stage1[2];
    
    // Final stage mux (1x 2:1)
    assign Z = sel[2] ? stage2[3:2] : stage2[1:0];
endmodule