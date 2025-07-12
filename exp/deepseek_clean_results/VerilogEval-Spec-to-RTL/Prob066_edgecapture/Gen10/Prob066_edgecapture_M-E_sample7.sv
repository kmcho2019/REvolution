module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] stage1;  // First sampling stage
    reg [31:0] stage2;  // Second sampling stage
    reg [31:0] captured; // Sticky capture register

    always @(posedge clk) begin
        if (reset) begin
            stage1 <= 32'b0;
            stage2 <= 32'b0;
            captured <= 32'b0;
        end
        else begin
            // Pipeline the input through two stages
            stage1 <= in;
            stage2 <= stage1;
            
            // Detect falling edges (1 in stage2, 0 in stage1)
            // and combine with existing captures
            captured <= captured | (stage2 & ~stage1);
        end
    end

    assign out = captured;

endmodule