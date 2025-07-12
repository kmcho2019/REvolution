module freq_divbyodd #(
    parameter integer NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,     // Active low asynchronous reset
    output reg  clk_div
);

    // Check parameter at compile time
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV parameter must be an odd number.");
        end
        if (NUM_DIV < 3) begin
            $error("NUM_DIV parameter must be >= 3.");
        end
    end

    // Width for counter
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] counter = 0;
    reg direction = 1'b1; // 1 means counting up, 0 means counting down

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
            direction <= 1'b1;
            clk_div <= 1'b0;
        end else begin
            // Update counter based on direction
            if (direction) begin
                if (counter == NUM_DIV - 1) begin
                    direction <= 1'b0; // switch direction to down
                    // Toggle clk_div when reaching top count on down edge next cycle
                    clk_div <= ~clk_div;
                    counter <= counter - 1;
                end else begin
                    counter <= counter + 1;
                end
            end else begin
                if (counter == 0) begin
                    direction <= 1'b1; // switch direction to up
                    // Toggle clk_div when reaching bottom count on up edge next cycle
                    clk_div <= ~clk_div;
                    counter <= counter + 1;
                end else begin
                    counter <= counter - 1;
                end
            end
        end
    end

endmodule