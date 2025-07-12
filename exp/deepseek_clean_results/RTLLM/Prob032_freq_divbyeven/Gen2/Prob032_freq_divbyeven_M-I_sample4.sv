module freq_diveven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

parameter NUM_DIV = 4; // Must be even and >= 2

// Validate parameter at compile time
initial begin
    if (NUM_DIV < 2 || NUM_DIV[0] != 0) begin
        $error("NUM_DIV must be even and >= 2");
        $finish;
    end
end

localparam HALF_CYCLES = NUM_DIV / 2;
localparam CNT_WIDTH = $clog2(HALF_CYCLES);

reg [CNT_WIDTH-1:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        clk_div <= 0;
    end
    else begin
        // Count half cycles (toggle every NUM_DIV/2 cycles)
        if (cnt == HALF_CYCLES - 1) begin
            cnt <= 0;
            clk_div <= ~clk_div;
        end
        else begin
            cnt <= cnt + 1;
        end
    end
end

endmodule