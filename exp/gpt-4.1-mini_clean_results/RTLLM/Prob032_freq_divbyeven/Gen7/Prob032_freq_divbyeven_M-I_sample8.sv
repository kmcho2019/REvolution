module freq_diveven #(
    parameter integer NUM_DIV = 4  // Must be even and >= 2
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Check that NUM_DIV is even and >= 2 at compile time
    generate
        if (NUM_DIV < 2) begin
            initial begin
                $error("NUM_DIV parameter must be >= 2. Current value: %0d", NUM_DIV);
            end
        end
        if (NUM_DIV % 2 != 0) begin
            initial begin
                $error("NUM_DIV parameter must be even. Current value: %0d", NUM_DIV);
            end
        end
    endgenerate

    localparam integer HALF_DIV = NUM_DIV / 2;
    localparam integer CNT_WIDTH = $clog2(HALF_DIV);

    reg [CNT_WIDTH-1:0] cnt;

    // Simulation assertion for NUM_DIV correctness (SystemVerilog)
    // If not using SystemVerilog, can be omitted or replaced with similar checking.
    // synthesis translate_off
    initial begin
        if (NUM_DIV < 2 || (NUM_DIV % 2) != 0) begin
            $fatal(1, "NUM_DIV parameter must be even and >= 2. Current value: %0d", NUM_DIV);
        end
    end
    // synthesis translate_on

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= {CNT_WIDTH{1'b0}};
            clk_div <= 1'b0;
        end else begin
            if (cnt == HALF_DIV - 1) begin
                cnt <= {CNT_WIDTH{1'b0}};
                clk_div <= ~clk_div;
            end else begin
                cnt <= cnt + 1'b1;
            end
        end
    end

endmodule