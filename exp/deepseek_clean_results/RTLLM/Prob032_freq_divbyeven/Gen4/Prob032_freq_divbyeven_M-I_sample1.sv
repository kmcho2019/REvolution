module freq_diveven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

localparam NUM_DIV = 4; // Must be even and >= 2
localparam HALF_CYCLES = NUM_DIV / 2;
localparam CNT_WIDTH = $clog2(HALF_CYCLES);

// Validate parameter at compile time
generate
    if (NUM_DIV < 2 || NUM_DIV[0] != 0) begin
        initial begin
            $error("NUM_DIV must be even and >= 2");
            $finish;
        end
    end
endgenerate

reg [CNT_WIDTH-1:0] cycle_count;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div <= 0;
        cycle_count <= 0;
    end
    else begin
        if (cycle_count == HALF_CYCLES - 1) begin
            clk_div <= ~clk_div;
            cycle_count <= 0;
        end
        else begin
            cycle_count <= cycle_count + 1;
        end
    end
end

endmodule