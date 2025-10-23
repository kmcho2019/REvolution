module freq_divbyodd (
    input  clk,    // Input clock signal
    input  rst_n,  // Active low reset signal
    output reg clk_div  // Divided clock output
);

parameter NUM_DIV = 5;  // Odd divisor value, default to 5

reg [2:0] cnt;  // Counter to track total number of cycles

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // Active low reset
        cnt <= 0;
        clk_div <= 1'b0;
    end else begin
        cnt <= cnt + 1;
        if (cnt == NUM_DIV - 1) begin
            clk_div <= ~clk_div;
            cnt <= 0;
        end
    end
end

endmodule