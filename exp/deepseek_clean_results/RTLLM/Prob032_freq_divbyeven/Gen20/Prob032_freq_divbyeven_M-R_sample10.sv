module freq_diveven (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

parameter NUM_DIV = 6;  // Must be even number
localparam DIV_HALF = NUM_DIV/2;
localparam CNT_WIDTH = $clog2(DIV_HALF);

// Parameter check for even division
initial begin
    if (NUM_DIV % 2 != 0) begin
        $error("NUM_DIV must be an even number");
    end
end

reg [CNT_WIDTH-1:0] cnt;
reg div_toggle;

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= {CNT_WIDTH{1'b0}};
        div_toggle <= 1'b0;
    end else begin
        if (cnt == DIV_HALF - 1) begin
            cnt <= {CNT_WIDTH{1'b0}};
            div_toggle <= ~div_toggle;
        end else begin
            cnt <= cnt + 1;
        end
    end
end

// Continuous assignment for output
assign clk_div = div_toggle;

endmodule