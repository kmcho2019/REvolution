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

localparam CNT_WIDTH = $clog2(NUM_DIV);
localparam HALF_DIV = (NUM_DIV - 1)/2;
reg [CNT_WIDTH-1:0] counter;

always @(posedge clk or negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
        clk_div <= 0;
    end else begin
        if (counter == NUM_DIV - 1) begin
            counter <= 0;
            clk_div <= ~clk_div;
        end else begin
            counter <= counter + 1;
            if (counter == HALF_DIV - 1) begin
                clk_div <= ~clk_div;
            end
        end
    end
end

endmodule