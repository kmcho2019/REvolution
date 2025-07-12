module freq_diveven (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

parameter NUM_DIV = 6;  // Must be even number
localparam DIV_HALF = NUM_DIV / 2;

reg [3:0] cnt;  // 4-bit counter

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 4'b0;
    end else begin
        if (cnt == NUM_DIV - 1) begin
            cnt <= 4'b0;
        end else begin
            cnt <= cnt + 1;
        end
    end
end

// Output generation - toggles when counter reaches half period
assign clk_div = (cnt < DIV_HALF) ? 1'b0 : 1'b1;

endmodule