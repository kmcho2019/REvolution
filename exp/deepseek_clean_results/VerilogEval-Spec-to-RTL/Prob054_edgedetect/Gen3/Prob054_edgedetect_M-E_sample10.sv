module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    // Two-stage shift register for each bit
    reg [7:0] stage1, stage2;

    always @(posedge clk) begin
        // Shift register operation
        stage2 <= stage1;
        stage1 <= in;
        
        // Edge detection logic
        pedge <= stage1 & ~stage2;
    end

endmodule