module freq_divbyodd #(
    parameter integer NUM_DIV = 5 // Must be odd
)(
    input  wire clk,
    input  wire rst_n,    // Active low synchronous reset
    output reg  clk_div
);

    // Compile-time check to ensure NUM_DIV is odd
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("Error: NUM_DIV parameter must be an odd number.");
        end
    end

    localparam integer CNT_WIDTH = $clog2(NUM_DIV);
    localparam integer HIGH_COUNT = (NUM_DIV + 1) / 2; // Number of cycles clk_div is high

    reg [CNT_WIDTH-1:0] cnt;

    always @(posedge clk) begin
        if (!rst_n) begin
            cnt <= 0;
            clk_div <= 1'b0;
        end else begin
            if (cnt == NUM_DIV - 1)
                cnt <= 0;
            else
                cnt <= cnt + 1;

            // clk_div is high when counter is less than HIGH_COUNT, else low
            if (cnt < HIGH_COUNT)
                clk_div <= 1'b1;
            else
                clk_div <= 1'b0;
        end
    end

endmodule