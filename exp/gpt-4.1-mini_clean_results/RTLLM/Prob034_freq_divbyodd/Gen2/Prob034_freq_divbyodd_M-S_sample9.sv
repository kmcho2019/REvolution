module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Check NUM_DIV is odd at elaboration time
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV (%0d) must be an odd number.", NUM_DIV);
            $finish;
        end
    end

    localparam integer TOGGLE1 = (NUM_DIV - 1) / 2;
    localparam integer TOGGLE2 = NUM_DIV - 1;

    localparam CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
            clk_div <= 0;
        end else begin
            if (counter == TOGGLE1 || counter == TOGGLE2) begin
                clk_div <= ~clk_div;
            end
            if (counter == TOGGLE2) begin
                counter <= 0;
            end else begin
                counter <= counter + 1;
            end
        end
    end

endmodule