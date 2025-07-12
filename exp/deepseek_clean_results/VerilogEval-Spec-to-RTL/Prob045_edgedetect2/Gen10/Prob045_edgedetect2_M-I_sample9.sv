module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    wire clk_enable = (in != prev_in);  // Clock gating condition

    always @(posedge clk) begin
        if (clk_enable) begin
            anyedge <= in ^ prev_in;
            prev_in <= in;
        end else begin
            anyedge <= 8'b0;  // Clear when no change
        end
    end

endmodule