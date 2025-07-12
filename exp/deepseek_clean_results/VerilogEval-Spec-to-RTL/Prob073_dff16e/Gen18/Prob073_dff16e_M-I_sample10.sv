module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

    // Clock gating logic for power optimization
    wire upper_byte_clk = byteena[1] ? clk : 1'b0;
    wire lower_byte_clk = byteena[0] ? clk : 1'b0;

    // Shared reset logic for area optimization
    always @(posedge clk) begin
        if (!resetn) begin
            q <= 16'b0;
        end else begin
            // Upper byte update with clock gating
            if (upper_byte_clk) begin
                q[15:8] <= d[15:8];
            end
            
            // Lower byte update with clock gating
            if (lower_byte_clk) begin
                q[7:0] <= d[7:0];
            end
        end
    end

endmodule