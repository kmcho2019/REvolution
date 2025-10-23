module freq_divbyodd #(
    parameter integer NUM_DIV = 5 // Must be odd
)(
    input  wire clk,
    input  wire rst_n,    // Active low asynchronous reset
    output wire clk_div
);

    // Compile-time check for odd NUM_DIV
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV parameter must be an odd number.");
        end
    end

    localparam integer HALF_COUNT = (NUM_DIV - 1) / 2;

    // Counter width
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    // Counter on rising edge of clk
    reg [CNT_WIDTH-1:0] cnt_rise;
    reg clk_div1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_rise <= {CNT_WIDTH{1'b0}};
            clk_div1 <= 1'b0;
        end else begin
            if (cnt_rise == NUM_DIV - 1)
                cnt_rise <= {CNT_WIDTH{1'b0}};
            else
                cnt_rise <= cnt_rise + 1'b1;

            if (cnt_rise == HALF_COUNT)
                clk_div1 <= ~clk_div1;
        end
    end

    // Counter on falling edge of clk
    reg [CNT_WIDTH-1:0] cnt_fall;
    reg clk_div2;

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_fall <= {CNT_WIDTH{1'b0}};
            clk_div2 <= 1'b0;
        end else begin
            if (cnt_fall == NUM_DIV - 1)
                cnt_fall <= {CNT_WIDTH{1'b0}};
            else
                cnt_fall <= cnt_fall + 1'b1;

            if (cnt_fall == HALF_COUNT)
                clk_div2 <= ~clk_div2;
        end
    end

    // Combine clk_div1 and clk_div2 via XOR to achieve 50% duty cycle output at clk_div
    assign clk_div = clk_div1 ^ clk_div2;

endmodule