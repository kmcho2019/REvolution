module freq_diveven #(
    parameter NUM_DIV = 8,  // Must be an even number
    parameter CNT_WIDTH = $clog2(NUM_DIV)  // Dynamic counter width
)(
    input  clk,    // Input clock signal
    input  rst_n,  // Active-low reset signal
    output reg clk_div  // Divided clock output signal
);

reg [CNT_WIDTH-1:0] cnt; // Dynamic width counter

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= '0;
        clk_div <= 1'b0;
    end else begin
        if (cnt == (NUM_DIV / 2 - 1)) begin
            cnt <= '0;
            clk_div <= ~clk_div;
        end else begin
            cnt <= cnt + 1;
        end
    end
end

endmodule