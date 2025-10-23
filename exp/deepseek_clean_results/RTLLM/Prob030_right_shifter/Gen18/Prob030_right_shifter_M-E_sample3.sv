module right_shifter (
    input wire clk,
    input wire d,
    output reg [7:0] q
);

// Pipeline registers
reg [7:0] stage1, stage2;

always @(posedge clk) begin
    // First pipeline stage: capture input and partial shift
    stage1 <= {d, stage1[7:1]};
    
    // Second pipeline stage: complete the shift
    stage2 <= stage1;
    
    // Output assignment
    q <= stage2;
end

endmodule