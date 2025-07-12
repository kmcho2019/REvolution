// Novel frequency divider module using dual-stage counter approach
module freq_diveven #(
    parameter NUM_DIV = 2  // Even number division factor
) (
    input clk,        // Input clock signal
    input rst_n,      // Active-low reset signal
    output reg clk_div // Divided clock output signal
);

// Check if NUM_DIV is an even number
initial begin
    if (NUM_DIV % 2!= 0) begin
        $fatal("NUM_DIV must be an even number.");
    end
end

// Calculate the required counter width based on NUM_DIV
localparam COARSE_CNT_WIDTH = $clog2(NUM_DIV / 4);
localparam FINE_CNT_WIDTH = $clog2(2);

reg [COARSE_CNT_WIDTH-1:0] coarse_cnt;  // Coarse counter
reg [FINE_CNT_WIDTH-1:0] fine_cnt;      // Fine counter

// Sequential logic for counter update and divided clock output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        coarse_cnt <= '0;
        fine_cnt <= '0;
        clk_div <= '0;
    end else begin
        if (coarse_cnt == (NUM_DIV / 4 - 1) && fine_cnt == (2 - 1)) begin
            coarse_cnt <= '0;
            fine_cnt <= '0;
            clk_div <= ~clk_div;
        end else if (fine_cnt == (2 - 1)) begin
            coarse_cnt <= coarse_cnt + 1;
            fine_cnt <= '0;
        end else begin
            fine_cnt <= fine_cnt + 1;
        end
    end
end

endmodule