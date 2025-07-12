module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] sync_stage1, sync_stage2;

    always @(posedge clk) begin
        // Two-stage synchronizer
        sync_stage1 <= in;
        sync_stage2 <= sync_stage1;
        
        // Edge detection with registered output
        anyedge <= sync_stage1 ^ sync_stage2;
    end

endmodule