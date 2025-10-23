module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd number >=3
) (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

// Parameter validation
initial begin
    if (NUM_DIV < 3 || NUM_DIV % 2 == 0) begin
        $error("NUM_DIV must be an odd number >= 3");
        $finish;
    end
end

localparam CNT_WIDTH = $clog2(NUM_DIV*2);
localparam HALF_PERIOD = NUM_DIV;

// Double-rate counter (counts on both edges)
reg [CNT_WIDTH-1:0] cnt;

always @(posedge clk or negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        clk_div <= 0;
    end else begin
        if (cnt == (2*NUM_DIV - 1)) begin
            cnt <= 0;
        end else begin
            cnt <= cnt + 1;
        end
        
        // Toggle at half period for 50% duty cycle
        if (cnt == 0) begin
            clk_div <= 1;
        end else if (cnt == HALF_PERIOD) begin
            clk_div <= 0;
        end
    end
end

endmodule