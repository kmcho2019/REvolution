module freq_diveven #(
    parameter integer NUM_DIV = 4  // Must be an even number
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Counter width calculation to accommodate NUM_DIV/2 count max
    localparam CNT_WIDTH = (NUM_DIV > 0) ? $clog2(NUM_DIV/2 + 1) : 1;

    reg [CNT_WIDTH-1:0] cnt;

    // Synthesis-time check for even NUM_DIV
    initial begin
        if (NUM_DIV == 0 || (NUM_DIV % 2) != 0) begin
            $error("Parameter NUM_DIV must be a non-zero even number.");
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= {CNT_WIDTH{1'b0}};
            clk_div <= 1'b0;
        end else begin
            if (cnt == (NUM_DIV/2)) begin
                cnt     <= {CNT_WIDTH{1'b0}};
                clk_div <= ~clk_div;  // Toggle output clock on reaching half period
            end else begin
                cnt <= cnt + 1'b1;
            end
        end
    end

endmodule