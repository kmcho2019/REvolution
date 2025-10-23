module freq_divbyodd #(parameter NUM_DIV = 5) (
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);
    // Parameter check at elaboration time
    initial begin
        if (NUM_DIV < 3 || (NUM_DIV % 2) == 0) begin
            $error("NUM_DIV must be an odd number >= 3");
        end
    end

    localparam HALF_COUNT = (NUM_DIV - 1) / 2;
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
            clk_div <= 0;
        end else begin
            if (cnt == NUM_DIV - 1) begin
                cnt <= 0;
                clk_div <= ~clk_div;
            end else begin
                cnt <= cnt + 1;
                if (cnt == HALF_COUNT) begin
                    clk_div <= ~clk_div;
                end
            end
        end
    end

endmodule