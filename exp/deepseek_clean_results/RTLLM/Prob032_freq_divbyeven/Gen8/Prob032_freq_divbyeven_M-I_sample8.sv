module freq_divbyeven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

parameter NUM_DIV = 4;  // Must be even and >= 2

// Validate parameter
initial begin
    if (NUM_DIV < 2 || NUM_DIV[0] != 0) begin
        $error("NUM_DIV must be even and >= 2. Current value: %0d", NUM_DIV);
        $finish;
    end
end

localparam CNT_WIDTH = $clog2(NUM_DIV);
localparam CNT_MAX = (NUM_DIV/2) - 1;
reg [CNT_WIDTH-1:0] cnt;

always @(posedge clk) begin
    if (!rst_n) begin
        cnt <= 0;
        clk_div <= 1'b0;
    end
    else begin
        if (cnt == CNT_MAX) begin
            cnt <= 0;
            clk_div <= ~clk_div;
        end
        else begin
            cnt <= cnt + 1;
        end
    end
end

endmodule