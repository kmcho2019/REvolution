module freq_divbyodd #(
    parameter integer NUM_DIV = 5  // Must be an odd number
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Compile-time check for odd NUM_DIV
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV parameter must be an odd number.");
        end
    end

    localparam integer TOGGLE_POINT1 = 0;
    localparam integer TOGGLE_POINT2 = (NUM_DIV - 1) >> 1;

    localparam integer CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= 0;
            clk_div <= 0;
        end else begin
            if (cnt == NUM_DIV - 1)
                cnt <= 0;
            else
                cnt <= cnt + 1;

            // Toggle clk_div at defined toggle points
            if (cnt == TOGGLE_POINT1 || cnt == TOGGLE_POINT2) begin
                clk_div <= ~clk_div;
            end
        end
    end

endmodule