module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd number
) (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

// Verify odd division factor
initial begin
    if (NUM_DIV % 2 == 0) begin
        $error("NUM_DIV must be an odd number");
        $finish;
    end
end

localparam FULL_CYCLE = 2 * NUM_DIV;
reg [31:0] counter;

always @(posedge clk or negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
        clk_div <= 0;
    end
    else begin
        if (counter == FULL_CYCLE - 1) begin
            counter <= 0;
        end
        else begin
            counter <= counter + 1;
        end
        
        // Update output at both edges
        if (counter < NUM_DIV) begin
            clk_div <= 1;
        end
        else begin
            clk_div <= 0;
        end
    end
end

endmodule