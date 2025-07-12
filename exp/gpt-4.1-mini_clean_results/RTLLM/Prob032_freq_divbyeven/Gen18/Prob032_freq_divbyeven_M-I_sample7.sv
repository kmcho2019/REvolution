module freq_diveven #(
    parameter integer NUM_DIV = 4  // Must be even and >= 2
)(
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Parameter check using generate-time assertion (Verilog-2001 style)
    // Synthesis tools supporting SystemVerilog can use 'assert' instead.
    // This will cause elaboration errors for invalid parameter values.
    generate
        if (NUM_DIV < 2) begin
            initial $error("NUM_DIV parameter (%0d) must be >= 2", NUM_DIV);
        end
        if (NUM_DIV % 2 != 0) begin
            initial $error("NUM_DIV parameter (%0d) must be even", NUM_DIV);
        end
    endgenerate

    // Calculate minimum bit width required for counter:
    // counter max count = HALF_PERIOD -1 = (NUM_DIV/2)-1
    // width = ceil(log2(HALF_PERIOD))
    function integer clog2;
        input integer value;
        integer i;
        begin
            clog2 = 0;
            for (i = value-1; i > 0; i = i >> 1)
                clog2 = clog2 + 1;
        end
    endfunction

    localparam integer HALF_PERIOD = NUM_DIV >> 1;
    localparam integer CNT_WIDTH = clog2(HALF_PERIOD);

    reg [CNT_WIDTH-1:0] cnt = 0;
    reg clk_div_reg = 0;

    always @(posedge clk) begin
        if (!rst_n) begin
            cnt <= 0;
            clk_div_reg <= 0;
        end else begin
            if (cnt == HALF_PERIOD - 1) begin
                cnt <= 0;
                clk_div_reg <= ~clk_div_reg;
            end else begin
                cnt <= cnt + 1'b1;
            end
        end
    end

    assign clk_div = clk_div_reg;

endmodule