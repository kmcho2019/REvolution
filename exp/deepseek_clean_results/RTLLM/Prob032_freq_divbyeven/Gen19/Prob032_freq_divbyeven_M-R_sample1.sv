module freq_diveven (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Parameters
parameter NUM_DIV = 6;  // Division factor (must be even and >= 2)

// Derived parameters
localparam DIV_HALF = NUM_DIV / 2;
localparam CNT_WIDTH = $clog2(DIV_HALF);
localparam CNT_MAX = DIV_HALF - 1;

// Parameter validation
initial begin
    if (NUM_DIV % 2 != 0) begin
        $error("NUM_DIV must be even number");
    end
    if (NUM_DIV < 2) begin
        $error("NUM_DIV must be >= 2");
    end
end

// Counter register (sized to minimum required bits)
reg [CNT_WIDTH-1:0] cnt;
reg toggle;

// Counter logic
always @(posedge clk) begin
    if (!rst_n) begin
        cnt <= {CNT_WIDTH{1'b0}};
        toggle <= 1'b0;
    end else begin
        if (cnt == CNT_MAX) begin
            cnt <= {CNT_WIDTH{1'b0}};
            toggle <= ~toggle;
        end else begin
            cnt <= cnt + 1;
        end
    end
end

// Clock output assignment
assign clk_div = toggle;

endmodule