module freq_diveven (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

parameter NUM_DIV = 6;  // Must be even number
localparam DIV_HALF = NUM_DIV / 2;

reg [3:0] cnt;      // 4-bit counter
reg toggle;         // Toggle control signal

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 4'b0;
        toggle <= 1'b0;
    end else begin
        if (cnt == DIV_HALF - 1) begin
            cnt <= 4'b0;
            toggle <= ~toggle;
        end else begin
            cnt <= cnt + 1;
        end
    end
end

// Output generation
assign clk_div = toggle;

endmodule