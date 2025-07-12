module freq_divbyodd #(
    parameter integer NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,   // Active low asynchronous reset
    output reg  clk_div  // Divided clock output
);

    // Check at compile time that NUM_DIV is odd
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV parameter must be an odd number.");
        end
    end

    // Calculate half period: number of counts before toggling output in one half-cycle
    localparam integer HALF_PERIOD = (NUM_DIV - 1) / 2;

    // Calculate counter width
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= 0;
            clk_div <= 0;
        end else begin
            if (cnt == NUM_DIV - 1) begin
                cnt <= 0;
                clk_div <= ~clk_div;  // Toggle output at end of full period
            end else begin
                cnt <= cnt + 1'b1;
                // Toggle output at halfway count to approximate 50% duty cycle
                if (cnt == HALF_PERIOD) begin
                    clk_div <= ~clk_div;
                end
            end
        end
    end

endmodule