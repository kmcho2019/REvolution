module freq_diveven #(
    parameter NUM_DIV = 10  // Division factor (even number)
) (
    input clk,  // Input clock signal
    input rst_n,  // Active-low reset signal
    output reg clk_div  // Divided clock output signal
);

reg [3:0] cnt;  // 4-bit counter

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Initialize the counter and divided clock on reset
        cnt <= 4'b0;
        clk_div <= 1'b0;
    end else begin
        if (cnt < (NUM_DIV / 2 - 1)) begin
            // Increment the counter without changing the divided clock
            cnt <= cnt + 1;
        end else begin
            // Reset the counter and toggle the divided clock
            cnt <= 4'b0;
            clk_div <= ~clk_div;
        end
    end
end

endmodule