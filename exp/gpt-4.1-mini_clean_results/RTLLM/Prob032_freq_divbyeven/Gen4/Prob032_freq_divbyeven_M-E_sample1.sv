module freq_diveven #(
    parameter NUM_DIV = 6  // Must be even
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Calculate counter width based on NUM_DIV/2 - 1
    localparam HALF_DIV = NUM_DIV >> 1;
    localparam CNT_WIDTH = $clog2(HALF_DIV);

    // Synthesis-time check to ensure NUM_DIV is even and greater than zero
    initial begin
        if (NUM_DIV == 0 || (NUM_DIV % 2) != 0) begin
            $error("Parameter NUM_DIV must be a non-zero even number");
            $finish;
        end
    end

    reg [CNT_WIDTH-1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= {CNT_WIDTH{1'b0}};
            clk_div <= 1'b0;
        end else if (cnt == HALF_DIV - 1) begin
            cnt     <= {CNT_WIDTH{1'b0}};
            clk_div <= ~clk_div;
        end else begin
            cnt <= cnt + 1'b1;
        end
    end

endmodule