module freq_diveven #(
    parameter NUM_DIV = 8 // Even number division factor
)(
    input  wire        clk,    // Input clock signal
    input  wire        rst_n,  // Active-low reset signal
    output wire        clk_div // Divided clock output signal
);

reg [3:0] cnt; // 4-bit counter
reg       clk_div; // Divided clock output signal

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the counter and divided clock output on reset
        cnt <= 4'b0;
        clk_div <= 1'b0;
    end else begin
        if (cnt < (NUM_DIV / 2 - 1)) begin
            // Increment the counter without changing the divided clock output
            cnt <= cnt + 1'b1;
        end else begin
            // Reset the counter and toggle the divided clock output
            cnt <= 4'b0;
            clk_div <= ~clk_div;
        end
    end
end

endmodule