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

localparam HALF_DIV = (NUM_DIV - 1)/2;
reg [31:0] counter;

always @(posedge clk or negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
        clk_div <= 0;
    end else begin
        // Increment counter on both edges
        counter <= (counter == NUM_DIV - 1) ? 0 : counter + 1;
        
        // Toggle at half and full cycle points
        if (counter == HALF_DIV || counter == NUM_DIV - 1) begin
            clk_div <= ~clk_div;
        end
    end
end

endmodule