module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Check that NUM_DIV is odd at compile time
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV must be odd, but is %0d", NUM_DIV);
        end
    end

    localparam HALF_DIV = (NUM_DIV - 1) / 2;

    reg [$clog2(NUM_DIV)-1:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
            clk_div <= 0;
        end else begin
            if (counter == NUM_DIV - 1) begin
                counter <= 0;
                clk_div <= ~clk_div;  // Toggle at end of full period
            end else if (counter == HALF_DIV) begin
                counter <= counter + 1;
                clk_div <= ~clk_div;  // Toggle at half period
            end else begin
                counter <= counter + 1;
            end
        end
    end

endmodule