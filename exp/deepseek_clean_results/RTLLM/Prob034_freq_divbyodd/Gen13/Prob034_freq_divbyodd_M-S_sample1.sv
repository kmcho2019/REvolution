module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

    // Validate parameter is odd
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV must be an odd number");
            $finish;
        end
    end

    localparam CNT_MAX = NUM_DIV - 1;
    localparam TOGGLE_POINT = (NUM_DIV - 1) / 2;
    localparam CNT_WIDTH = $clog2(CNT_MAX + 1);

    reg [CNT_WIDTH-1:0] counter;

    always @(posedge clk or negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
            clk_div <= 0;
        end else begin
            if (counter == CNT_MAX) begin
                counter <= 0;
            end else begin
                counter <= counter + 1;
            end

            if (counter == TOGGLE_POINT || counter == CNT_MAX) begin
                clk_div <= ~clk_div;
            end
        end
    end

endmodule