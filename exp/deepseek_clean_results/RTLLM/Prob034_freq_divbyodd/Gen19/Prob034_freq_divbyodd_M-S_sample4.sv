module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd number
) (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

// Validate parameter
initial begin
    if (NUM_DIV % 2 == 0) begin
        $error("NUM_DIV must be an odd number");
        $finish;
    end
end

localparam CNT_MAX = NUM_DIV - 1;
localparam MID_CNT = (NUM_DIV - 1)/2;

reg [31:0] counter;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
        clk_div <= 0;
    end else begin
        if (counter == CNT_MAX) begin
            counter <= 0;
            clk_div <= 1'b0;
        end else begin
            counter <= counter + 1;
            if (counter == MID_CNT)
                clk_div <= 1'b1;
        end
    end
end

endmodule