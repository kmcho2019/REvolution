module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be an odd number
)(
    input  wire clk,
    input  wire rst_n,    // Active low reset
    output reg  clk_div
);

    // Compile-time check for odd NUM_DIV
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV parameter must be an odd number.");
        end
    end

    // Counter width to hold values up to NUM_DIV-1
    localparam COUNTER_WIDTH = $clog2(NUM_DIV);

    reg [COUNTER_WIDTH-1:0] counter;

    // Toggle points
    localparam integer TOGGLE_POINT1 = 0;
    localparam integer TOGGLE_POINT2 = (NUM_DIV - 1) / 2 + 1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
            clk_div <= 0;
        end else begin
            if (counter == NUM_DIV - 1)
                counter <= 0;
            else
                counter <= counter + 1;

            if (counter == TOGGLE_POINT1 || counter == TOGGLE_POINT2)
                clk_div <= ~clk_div;
        end
    end

endmodule