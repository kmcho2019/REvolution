module freq_divbyeven #(
    parameter integer NUM_DIV = 4  // Must be even
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Local parameters
    localparam integer HALF_DIV = NUM_DIV / 2;
    localparam integer CNT_WIDTH = $clog2(HALF_DIV);

    // Compile-time check for even NUM_DIV
    generate
        if (NUM_DIV % 2 != 0) begin
            initial begin
                $error("NUM_DIV parameter must be even. Current value: %0d", NUM_DIV);
            end
        end
    endgenerate

    reg [CNT_WIDTH-1:0] cnt;

    // Counter process: increments or resets at terminal count
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
        end else begin
            if (cnt == HALF_DIV - 1)
                cnt <= 0;
            else
                cnt <= cnt + 1'b1;
        end
    end

    // clk_div toggles when counter reaches terminal count
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_div <= 1'b0;
        end else begin
            if (cnt == HALF_DIV - 1)
                clk_div <= ~clk_div;
        end
    end

endmodule