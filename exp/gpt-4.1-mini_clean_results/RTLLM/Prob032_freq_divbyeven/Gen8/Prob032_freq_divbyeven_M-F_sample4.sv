module freq_divbyeven #(
    parameter integer NUM_DIV = 4  // Must be even
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    localparam HALF_DIV = NUM_DIV / 2;
    localparam CNT_WIDTH = $clog2(HALF_DIV);

    // Compile-time check for even NUM_DIV
    generate
        if (NUM_DIV % 2 != 0) begin
            initial begin
                $error("NUM_DIV parameter must be even. Current value: %0d", NUM_DIV);
            end
        end
    endgenerate

    reg [CNT_WIDTH-1:0] cnt;
    wire toggle_pulse;

    // Counter logic: increment until HALF_DIV-1, then reset to 0
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
        end else if (cnt == HALF_DIV - 1) begin
            cnt <= 0;
        end else begin
            cnt <= cnt + 1'b1;
        end
    end

    // Generate toggle pulse when counter reaches HALF_DIV-1
    assign toggle_pulse = (cnt == HALF_DIV - 1);

    // clk_div toggles on toggle_pulse rising edge (every HALF_DIV clocks)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_div <= 0;
        end else if (toggle_pulse) begin
            clk_div <= ~clk_div;
        end
    end

endmodule