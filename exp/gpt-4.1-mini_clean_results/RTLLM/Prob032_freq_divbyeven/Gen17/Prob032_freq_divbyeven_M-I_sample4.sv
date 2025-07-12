module freq_diveven #(
    parameter integer NUM_DIV = 4  // Must be even and >= 2
) (
    input  wire clk,
    input  wire rst_n,     // Active low asynchronous reset
    output reg  clk_div
);

    // Compile-time parameter check: NUM_DIV must be even and >= 2
    // Generate block will cause a compile-time error if this condition fails.
    generate
        if (NUM_DIV < 2) begin
            initial begin
                $error("Parameter NUM_DIV must be >= 2. Given: %0d", NUM_DIV);
            end
        end else if (NUM_DIV % 2 != 0) begin
            initial begin
                $error("Parameter NUM_DIV must be even. Given: %0d", NUM_DIV);
            end
        end
    endgenerate

    // Function to calculate clog2 (ceiling log2)
    function integer clog2;
        input integer value;
        integer i;
        begin
            clog2 = 0;
            for (i = value - 1; i > 0; i = i >> 1)
                clog2 = clog2 + 1;
        end
    endfunction

    localparam integer HALF_DIV = NUM_DIV >> 1;
    localparam integer CNT_WIDTH = (HALF_DIV > 1) ? clog2(HALF_DIV) : 1;

    reg [CNT_WIDTH-1:0] cnt;

    // Asynchronous reset for better timing performance and clear reset behavior
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= {CNT_WIDTH{1'b0}};
            clk_div <= 1'b0;
        end else begin
            if (cnt == HALF_DIV - 1) begin
                cnt <= {CNT_WIDTH{1'b0}};
                clk_div <= ~clk_div;
            end else begin
                cnt <= cnt + 1'b1;
            end
        end
    end

endmodule