module freq_diveven #(
    parameter integer NUM_DIV = 4  // Must be even
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Compile-time assertion to check if NUM_DIV is even
    initial begin
        if (NUM_DIV % 2 != 0) begin
            $error("NUM_DIV parameter must be an even number.");
            $finish;
        end
    end

    // Calculate required counter width dynamically
    localparam CNT_WIDTH = $clog2(NUM_DIV >> 1);

    reg [CNT_WIDTH-1:0] cnt;

    // Combined counter and toggle logic with asynchronous active-low reset
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