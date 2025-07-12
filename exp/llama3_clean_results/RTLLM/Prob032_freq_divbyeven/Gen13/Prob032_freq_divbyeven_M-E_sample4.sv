module freq_diveven #(
    parameter NUM_DIV = 8 // Must be an even number
) (
    input  wire clk,    // Input clock signal
    input  wire rst_n,  // Active-low reset signal
    output reg  clk_div  // Divided clock output signal
);

reg [3:0] cnt; // Counter to track clock cycles

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 4'b0;
        clk_div <= 1'b0;
    end else begin
        cnt <= (cnt + 1) % (NUM_DIV / 2);
        if (cnt == 0) begin
            clk_div <= ~clk_div;
        end
    end
end

endmodule