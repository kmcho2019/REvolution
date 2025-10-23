module freq_diveven #(
    parameter integer NUM_DIV = 4  // Must be an even number >= 2
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Calculate counter width based on NUM_DIV
    localparam integer CNT_WIDTH = $clog2(NUM_DIV >> 1);

    // Parameter validity check
    initial begin
        if (NUM_DIV < 2) begin
            $error("NUM_DIV parameter (%0d) must be >= 2", NUM_DIV);
        end
        if ((NUM_DIV & 1) != 0) begin
            $error("NUM_DIV parameter (%0d) must be even", NUM_DIV);
        end
    end

    reg [CNT_WIDTH-1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= {CNT_WIDTH{1'b0}};
            clk_div <= 1'b0;
        end else begin
            if (cnt == ((NUM_DIV >> 1) - 1)) begin
                cnt     <= {CNT_WIDTH{1'b0}};
                clk_div <= ~clk_div;
            end else begin
                cnt <= cnt + 1'b1;
            end
        end
    end

endmodule