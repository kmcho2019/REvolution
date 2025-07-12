module freq_diveven #(
    parameter integer NUM_DIV = 4 // Must be even and >= 2
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Parameter validity check
    initial begin
        if (NUM_DIV < 2 || (NUM_DIV % 2) != 0) begin
            $error("NUM_DIV parameter (%0d) must be even and >= 2", NUM_DIV);
        end
    end

    // Calculate minimum width needed for counter
    localparam integer CNT_WIDTH = $clog2(NUM_DIV);
    localparam integer MAX_COUNT = NUM_DIV - 1;
    localparam integer HALF_COUNT = NUM_DIV >> 1;

    reg [CNT_WIDTH-1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= {CNT_WIDTH{1'b0}};
            clk_div <= 1'b0;
        end else begin
            if (cnt == MAX_COUNT) begin
                cnt <= {CNT_WIDTH{1'b0}};
            end else begin
                cnt <= cnt + 1'b1;
            end

            if (cnt == (HALF_COUNT - 1)) begin
                clk_div <= ~clk_div;
            end
        end
    end

endmodule