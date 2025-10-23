// Refactored frequency divider module
module freq_diveven #(
    parameter NUM_DIV = 2  // Even number division factor, must be greater than 0
) (
    input clk,        // Input clock signal
    input rst_n,      // Active-low reset signal
    output reg clk_div // Divided clock output signal
);

// Validate if NUM_DIV is an even number
generate
    if (NUM_DIV <= 0 || (NUM_DIV % 2)!= 0) begin
        $error("NUM_DIV must be an even number greater than 0");
    end
endgenerate

reg [3:0] cnt;  // 4-bit counter

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 0;
        clk_div <= 0;
    end else begin
        if (cnt < (NUM_DIV / 2 - 1)) begin
            cnt <= cnt + 1;
        end else begin
            cnt <= 0;
            clk_div <= ~clk_div;
        end
    end
end

endmodule

// Example testbench to instantiate the freq_diveven module
module freq_diveven_tb;
    reg clk;
    reg rst_n;
    wire clk_div;

    freq_diveven #(.NUM_DIV(4)) u_freq_diveven (
      .clk(clk),
      .rst_n(rst_n),
      .clk_div(clk_div)
    );

    initial begin
        clk = 0;
        rst_n = 0;
        #10;
        rst_n = 1;
        forever #5 clk = ~clk;
    end

    initial begin
        #100;
        $finish;
    end
endmodule