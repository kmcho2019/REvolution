module freq_diveven #(
    parameter integer NUM_DIV = 4  // Must be even and >= 2
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Check NUM_DIV validity at elaboration time
    initial begin
        if (NUM_DIV < 2 || (NUM_DIV % 2) != 0) begin
            $error("Parameter NUM_DIV must be even and >= 2. Given: %0d", NUM_DIV);
            $finish;
        end
    end

    // Function to compute clog2 for sizing counter
    function integer clog2;
        input integer value;
        integer i;
        begin
            clog2 = 0;
            for (i = value - 1; i > 0; i = i >> 1) begin
                clog2 = clog2 + 1;
            end
        end
    endfunction

    localparam integer CNT_MAX = NUM_DIV - 1;
    localparam integer CNT_WIDTH = clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] cnt;

    always @(posedge clk) begin
        if (!rst_n) begin
            cnt <= 0;
            clk_div <= 0;
        end else begin
            if (cnt == CNT_MAX) begin
                cnt <= 0;
                clk_div <= 0;  // End of cycle, clk_div low
            end else begin
                cnt <= cnt + 1;
                if (cnt == (NUM_DIV >> 1) - 1) begin
                    clk_div <= 1;  // Halfway point, clk_div high
                end
            end
        end
    end

endmodule