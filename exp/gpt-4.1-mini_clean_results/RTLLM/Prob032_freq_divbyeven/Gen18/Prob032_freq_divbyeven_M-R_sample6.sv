module freq_diveven #(
    parameter integer NUM_DIV = 4  // Must be an even number
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Check that NUM_DIV is even
    initial begin
        if (NUM_DIV % 2 != 0) begin
            $error("Parameter NUM_DIV must be even, but given %0d", NUM_DIV);
        end
    end

    localparam integer CNT_WIDTH = $clog2(NUM_DIV);
    localparam integer HALF_DIV = NUM_DIV >> 1;

    reg [CNT_WIDTH-1:0] cnt;

    // Counter process: counts up to HALF_DIV and resets
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= {CNT_WIDTH{1'b0}};
        end else begin
            if (cnt == HALF_DIV) begin
                cnt <= {CNT_WIDTH{1'b0}};
            end else begin
                cnt <= cnt + 1'b1;
            end
        end
    end

    // clk_div toggle process: toggles when counter reaches HALF_DIV
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_div <= 1'b0;
        end else if (cnt == HALF_DIV) begin
            clk_div <= ~clk_div;
        end
    end

endmodule