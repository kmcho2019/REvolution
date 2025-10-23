module freq_diveven(
    input  clk,       // Input clock signal
    input  rst_n,      // Active-low reset signal
    output reg clk_div // Divided clock output signal
);

parameter NUM_DIV = 4; // Division factor (even number)

reg [3:0] cnt;         // 4-bit counter

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset counter and divided clock output
        cnt <= 4'd0;
        clk_div <= 1'b0;
    end else begin
        if (cnt < (NUM_DIV / 2 - 1)) begin
            // Increment counter without changing divided clock output
            cnt <= cnt + 1;
        end else if (cnt == (NUM_DIV / 2 - 1)) begin
            // Reset counter and toggle divided clock output
            cnt <= 4'd0;
            clk_div <= ~clk_div;
        end
    end
end

endmodule