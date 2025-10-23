module freq_diveven #(
    parameter integer NUM_DIV = 4  // Must be an even number >= 2
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Parameter checks at elaboration time using generate-if
    generate
        if (NUM_DIV < 2) begin
            initial $error("Parameter NUM_DIV (%0d) must be >= 2", NUM_DIV);
        end
        if (NUM_DIV % 2 != 0) begin
            initial $error("Parameter NUM_DIV (%0d) must be even", NUM_DIV);
        end
    endgenerate

    // Compute the required bit width for the counter
    function integer clog2;
        input integer value;
        integer i;
        begin
            clog2 = 0;
            for (i = value - 1; i > 0; i = i >> 1)
                clog2 = clog2 + 1;
        end
    endfunction

    localparam integer CNT_WIDTH = clog2(NUM_DIV);

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

            // Toggle clk_div when counter reaches half the division period minus one
            if (cnt == (NUM_DIV >> 1) - 1) begin
                clk_div <= ~clk_div;
            end
        end
    end

endmodule