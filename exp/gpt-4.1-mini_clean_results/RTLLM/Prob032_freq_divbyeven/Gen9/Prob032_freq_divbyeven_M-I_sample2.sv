module freq_diveven #(
    parameter integer NUM_DIV = 4  // Must be even and >= 2
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Synthesis-time parameter check using generate block
    generate
        if ((NUM_DIV < 2) || (NUM_DIV % 2 != 0)) begin
            initial begin
                $error("Error: NUM_DIV must be even and >= 2. Given: %0d", NUM_DIV);
                $finish;
            end
        end
    endgenerate

    // Half division factor
    localparam integer HALF_DIV = NUM_DIV >> 1;

    // Calculate counter width with minimum 1 bit to avoid zero-width vectors
    localparam integer CNT_WIDTH = (HALF_DIV > 1) ? $clog2(HALF_DIV) : 1;

    reg [CNT_WIDTH-1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= {CNT_WIDTH{1'b0}};
            clk_div <= 1'b0;
        end else if (cnt == HALF_DIV - 1) begin
            cnt     <= {CNT_WIDTH{1'b0}};
            clk_div <= ~clk_div; // Toggle output after HALF_DIV cycles
        end else begin
            cnt <= cnt + 1'b1;
        end
    end

endmodule