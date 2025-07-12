module freq_divbyeven #(
    parameter integer NUM_DIV = 4  // Must be even and >= 2
) (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Compile-time check for parameter validity
    initial begin
        if ((NUM_DIV < 2) || (NUM_DIV % 2) != 0) begin
            $error("NUM_DIV must be even and >= 2 (got %0d)", NUM_DIV);
            $finish;
        end
    end

    localparam int HALF_DIV = NUM_DIV >> 1;
    localparam int CNT_WIDTH = $clog2(HALF_DIV);

    // Registers for counter and divided clock output
    reg [CNT_WIDTH-1:0] cnt = 0;
    reg clk_div_r = 0;

    // Combinational next state logic
    wire toggle = (cnt == (HALF_DIV - 1));
    wire [CNT_WIDTH-1:0] cnt_next = toggle ? {CNT_WIDTH{1'b0}} : cnt + 1;

    // Synchronous logic with synchronous active-low reset
    always @(posedge clk) begin
        if (!rst_n) begin
            cnt <= 0;
            clk_div_r <= 0;
        end else begin
            cnt <= cnt_next;
            if (toggle)
                clk_div_r <= ~clk_div_r;
        end
    end

    assign clk_div = clk_div_r;

endmodule