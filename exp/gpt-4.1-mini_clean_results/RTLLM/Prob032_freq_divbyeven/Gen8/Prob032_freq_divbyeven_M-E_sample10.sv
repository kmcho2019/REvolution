module freq_diveven #(
    parameter integer NUM_DIV = 4  // Must be even and >= 2
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Calculate half division factor
    localparam integer HALF_DIV = NUM_DIV / 2;

    // Calculate bit width for the counter
    localparam integer CNT_WIDTH = $clog2(HALF_DIV);

    // Counter register for counting input clock cycles
    reg [CNT_WIDTH-1:0] cnt;

    // Synchronous logic for counter and toggle flip-flop
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= {CNT_WIDTH{1'b0}};
            clk_div <= 1'b0;
        end else begin
            if (cnt == (HALF_DIV - 1)) begin
                cnt     <= {CNT_WIDTH{1'b0}};
                clk_div <= ~clk_div;  // Toggle output clock
            end else begin
                cnt <= cnt + 1'b1;
            end
        end
    end

endmodule