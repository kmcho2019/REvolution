module freq_diveven #(
    parameter integer NUM_DIV = 4  // Must be even and >= 2
) (
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Runtime check for valid NUM_DIV
    initial begin
        if ((NUM_DIV < 2) || (NUM_DIV % 2 != 0)) begin
            $error("Parameter NUM_DIV must be even and >= 2. Given: %0d", NUM_DIV);
            $finish;
        end
    end

    // Function to compute clog2 of a number
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
    localparam integer CNT_WIDTH = clog2(HALF_DIV);

    reg [CNT_WIDTH-1:0] cnt;

    always @(posedge clk) begin
        if (!rst_n) begin
            cnt <= 0;
            clk_div <= 0;
        end else begin
            if (cnt == HALF_DIV - 1) begin
                cnt <= 0;
                clk_div <= ~clk_div;
            end else begin
                cnt <= cnt + 1;
            end
        end
    end

endmodule