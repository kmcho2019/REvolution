module freq_diveven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
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

// Clock division logic
always @(posedge clk) begin
    if (!rst_n) begin
        // Synchronous reset
        cnt <= {CNT_WIDTH{1'b0}};
        clk_div <= 1'b0;
    end else begin
        if (cnt == CNT_MAX) begin
            // Reached half period - toggle output and reset counter
            cnt <= {CNT_WIDTH{1'b0}};
            clk_div <= ~clk_div;
        end else begin
            // Count clock cycles
            cnt <= cnt + 1;
        end
    end
end

endmodule