module freq_diveven #(
    parameter integer NUM_DIV = 4  // Must be even
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Compile-time assertion to ensure NUM_DIV is even
    initial begin
        if (NUM_DIV % 2 != 0) begin
            $error("Parameter NUM_DIV (%0d) must be an even number.", NUM_DIV);
        end
    end

    // Calculate counter width based on NUM_DIV
    localparam integer CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= {CNT_WIDTH{1'b0}};
            clk_div <= 1'b0;
        end else if (cnt == NUM_DIV - 1) begin
            cnt     <= {CNT_WIDTH{1'b0}};
            clk_div <= ~clk_div;
        end else begin
            cnt <= cnt + 1'b1;
        end
    end

endmodule