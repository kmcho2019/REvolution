module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd number
) (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

// Check if NUM_DIV is odd
initial begin
    if (NUM_DIV % 2 == 0) begin
        $error("NUM_DIV must be an odd number");
        $finish;
    end
end

localparam HALF_CYCLE = (NUM_DIV - 1)/2;
reg [31:0] counter;
reg toggle_rise, toggle_fall;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
        clk_div <= 0;
        toggle_rise <= 0;
        toggle_fall <= 0;
    end else begin
        // Main counter
        if (counter == NUM_DIV - 1) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end

        // Rising edge generation (at counter == 0)
        if (counter == 0) begin
            clk_div <= 1;
        end
        // Falling edge generation (at counter == HALF_CYCLE)
        else if (counter == HALF_CYCLE) begin
            clk_div <= 0;
        end
    end
end

endmodule