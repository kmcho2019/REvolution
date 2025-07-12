module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output [15:0] q
);
    // Clock gating cells
    wire upper_clk_en = byteena[1] | ~resetn;
    wire lower_clk_en = byteena[0] | ~resetn;
    
    wire upper_clk_gated;
    wire lower_clk_gated;
    
    // Clock gating implementation
    assign upper_clk_gated = clk & upper_clk_en;
    assign lower_clk_gated = clk & lower_clk_en;
    
    // Upper byte register (bits 15:8)
    always @(posedge upper_clk_gated) begin
        if (!resetn) begin
            q[15:8] <= 8'b0;
        end else begin
            q[15:8] <= d[15:8];
        end
    end
    
    // Lower byte register (bits 7:0)
    always @(posedge lower_clk_gated) begin
        if (!resetn) begin
            q[7:0] <= 8'b0;
        end else begin
            q[7:0] <= d[7:0];
        end
    end
endmodule