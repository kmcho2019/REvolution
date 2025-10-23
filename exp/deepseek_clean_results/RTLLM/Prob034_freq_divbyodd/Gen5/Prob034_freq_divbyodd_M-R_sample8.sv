module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

    localparam CNT_WIDTH = $clog2(2*NUM_DIV);  // Double range for dual-edge counting
    localparam THRESHOLD = NUM_DIV;             // Full period threshold
    localparam HALF_THRESH = NUM_DIV/2;         // Half period threshold
    
    reg [CNT_WIDTH-1:0] cnt;

    always @(posedge clk or negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
            clk_div <= 0;
        end
        else begin
            // Increment counter on both edges
            cnt <= (cnt == THRESHOLD-1) ? 0 : cnt + 1;
            
            // Toggle at half and full period
            if (cnt == HALF_THRESH-1 || cnt == THRESHOLD-1)
                clk_div <= ~clk_div;
        end
    end

endmodule