module freq_diveven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

parameter NUM_DIV = 6; // Default division factor (must be even)

// Calculate required counter width dynamically
localparam CNT_WIDTH = $clog2(NUM_DIV);
localparam CNT_MAX = (NUM_DIV >> 1) - 1; // NUM_DIV/2 - 1 using right shift

// Strict parameter validation
initial begin
    if (NUM_DIV < 2 || NUM_DIV % 2 != 0) begin
        $fatal(1, "NUM_DIV must be a positive even number (given: %0d)", NUM_DIV);
    end
end

reg [CNT_WIDTH-1:0] cnt; // Dynamic width counter

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= {CNT_WIDTH{1'b0}};
        clk_div <= 1'b0;
    end
    else begin
        if (cnt == CNT_MAX) begin
            cnt <= {CNT_WIDTH{1'b0}};
            clk_div <= ~clk_div;
        end
        else begin
            cnt <= cnt + 1'b1;
        end
    end
end

endmodule