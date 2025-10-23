module freq_diveven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

parameter NUM_DIV = 4;       // Must be even number
parameter CNT_WIDTH = 4;     // Counter width (adjust as needed)

reg [CNT_WIDTH-1:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= {CNT_WIDTH{1'b0}};
        clk_div <= 1'b0;
    end else begin
        if (cnt == NUM_DIV-1) begin
            cnt <= {CNT_WIDTH{1'b0}};
        end else begin
            cnt <= cnt + 1;
        end
        
        // Toggle at half period and full period
        if (cnt == (NUM_DIV/2)-1 || cnt == NUM_DIV-1) begin
            clk_div <= ~clk_div;
        end
    end
end

endmodule