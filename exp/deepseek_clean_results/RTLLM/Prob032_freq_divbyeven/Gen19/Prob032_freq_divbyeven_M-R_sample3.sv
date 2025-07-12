module freq_diveven (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

parameter NUM_DIV = 6;  // Must be even number >= 2
localparam DIV_HALF = NUM_DIV/2;
localparam CNT_WIDTH = (NUM_DIV <= 2) ? 1 : $clog2(DIV_HALF);
localparam CNT_MAX = DIV_HALF - 1;

reg [CNT_WIDTH-1:0] cnt;
reg toggle;

// Check parameter validity
initial begin
    if (NUM_DIV < 2 || NUM_DIV % 2 != 0) begin
        $error("NUM_DIV must be even and >= 2");
    end
end

// Combinational logic for toggle condition
wire cnt_max = (cnt == CNT_MAX);

// Sequential counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= {CNT_WIDTH{1'b0}};
    end else begin
        cnt <= cnt_max ? {CNT_WIDTH{1'b0}} : cnt + 1;
    end
end

// Toggle flip-flop
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        toggle <= 1'b0;
    end else if (cnt_max) begin
        toggle <= ~toggle;
    end
end

// Continuous output assignment
assign clk_div = toggle;

endmodule