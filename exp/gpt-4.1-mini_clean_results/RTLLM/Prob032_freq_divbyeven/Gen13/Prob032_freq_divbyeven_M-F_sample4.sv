module freq_divbyeven #(
    parameter integer NUM_DIV = 4  // Must be even and >= 2
) (
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Check at runtime if NUM_DIV is valid (even and >= 2)
    initial begin
        if ((NUM_DIV < 2) || (NUM_DIV % 2) != 0) begin
            $display("ERROR: NUM_DIV must be even and >= 2 (got %0d)", NUM_DIV);
            $finish;
        end
    end

    localparam integer CNT_WIDTH = (NUM_DIV <= 16) ? 4 :
                                   (NUM_DIV <= 32) ? 5 :
                                   (NUM_DIV <= 64) ? 6 :
                                   (NUM_DIV <= 128)? 7 : 8; // Up to 256 division

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

            // Toggle clk_div at half of NUM_DIV
            if (cnt == (NUM_DIV >> 1) - 1) begin
                clk_div <= ~clk_div;
            end
        end
    end

endmodule