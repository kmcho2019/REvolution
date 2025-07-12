module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be an odd number
)(
    input  wire clk,
    input  wire rst_n,    // Active low synchronous reset
    output reg  clk_div
);

    // Compile-time check for odd NUM_DIV
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV parameter must be an odd number.");
        end
    end

    localparam HALF_DIV = (NUM_DIV - 1) / 2;

    // Width of counter
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
            clk_div <= 0;
        end else begin
            if (cnt == NUM_DIV - 1) begin
                cnt <= 0;
            end else begin
                cnt <= cnt + 1;
            end

            // Output high if count <= HALF_DIV, else low
            // This creates a high pulse of (HALF_DIV+1) cycles, low pulse of (HALF_DIV) cycles
            // e.g., NUM_DIV=5 => high for 3 cycles, low for 2 cycles per period
            if (cnt <= HALF_DIV) begin
                clk_div <= 1;
            end else begin
                clk_div <= 0;
            end
        end
    end

endmodule