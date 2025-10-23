module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

    // Clock gating signals
    wire upper_byte_clk_en = byteena[1] || !resetn;
    wire lower_byte_clk_en = byteena[0] || !resetn;
    
    // Gated clocks
    wire upper_byte_clk;
    wire lower_byte_clk;
    
    // Clock gating cells (synthesis will infer or replace with technology-specific cells)
    assign upper_byte_clk = upper_byte_clk_en ? clk : 1'b0;
    assign lower_byte_clk = lower_byte_clk_en ? clk : 1'b0;

    always @(posedge upper_byte_clk or posedge lower_byte_clk) begin
        if (!resetn) begin
            q <= 16'b0;
        end else begin
            // Upper byte update
            if (upper_byte_clk_en && byteena[1]) begin
                q[15:8] <= d[15:8];
            end
            // Lower byte update
            if (lower_byte_clk_en && byteena[0]) begin
                q[7:0] <= d[7:0];
            end
        end
    end

endmodule