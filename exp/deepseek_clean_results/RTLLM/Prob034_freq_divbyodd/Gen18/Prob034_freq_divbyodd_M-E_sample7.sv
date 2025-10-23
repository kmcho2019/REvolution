module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd number
) (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

// Validate parameter
initial begin
    if (NUM_DIV % 2 == 0) begin
        $error("NUM_DIV must be an odd number");
        $finish;
    end
end

localparam CNT_MAX = NUM_DIV - 1;
localparam TOGGLE_HIGH = (NUM_DIV - 1)/2;
localparam TOGGLE_LOW = NUM_DIV - 1;

reg [31:0] counter;
wire counter_reset = (counter == CNT_MAX);

always @(posedge clk or negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
        clk_div <= 0;
    end else begin
        // Double-rate counter
        if (counter_reset)
            counter <= 0;
        else
            counter <= counter + 1;

        // Symmetric toggling
        if (counter == TOGGLE_HIGH)
            clk_div <= 1'b1;
        else if (counter == TOGGLE_LOW)
            clk_div <= 1'b0;
    end
end

endmodule