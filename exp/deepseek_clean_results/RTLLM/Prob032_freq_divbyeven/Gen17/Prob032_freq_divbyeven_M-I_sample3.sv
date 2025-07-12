module freq_diveven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

parameter NUM_DIV = 6;  // Must be even number
localparam DIV_HALF = NUM_DIV / 2;
localparam CNT_WIDTH = $clog2(DIV_HALF);
localparam CNT_MAX = DIV_HALF - 1;

// Validate parameter (synthesis-time check)
initial begin
    if (NUM_DIV % 2 != 0) begin
        $error("NUM_DIV must be even number");
    end
end

reg [CNT_WIDTH-1:0] cnt;  // Sized counter

// Counter and output logic
always @(posedge clk) begin
    if (!rst_n) begin
        cnt <= {CNT_WIDTH{1'b0}};
        clk_div <= 1'b0;
    end else begin
        if (cnt == CNT_MAX) begin
            cnt <= {CNT_WIDTH{1'b0}};
            clk_div <= ~clk_div;
        end else begin
            cnt <= cnt + 1;
        end
    end
end

endmodule